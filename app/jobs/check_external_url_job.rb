class CheckExternalUrlJob < ApplicationJob
  require "net/http"
  require "uri"

  def safe_perform(object)
    return unless object.external_url.present?
    new_size, new_type = get_attachment_info(object.external_url)
    object.update(
      size: new_size,
      mime_type: new_type,
    )
    object.validate!
    object.publish!
  rescue StandardError => e
    object.block! e.message
  end

  private

  def get_attachment_info(url, redirect_count = 0)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 5
    http.read_timeout = 5
    if uri.instance_of?(URI::HTTPS)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    response = http.head(uri.path, { 'User-Agent': USER_AGENT, 'Accept': "application/*" })
    if response.is_a?(Net::HTTPRedirection) && redirect_count < 10
      get_attachment_info(response["location"], redirect_count + 1)
    elsif response.is_a?(Net::HTTPSuccess) &&
          response.content_type.split("/")[0] == "application" &&
          response.content_length > 0
      return response.content_length, response.content_type
    else
      raise I18n.t("errors.messages.url_is_not_attachment")
    end
  end
end
