class CheckExternalUrlJob < ApplicationJob
  require "net/http"
  require "uri"

  def safe_perform(package)
    return unless package.external?
    new_size = get_attachment_size(package.external_url).to_i
    package.update(size: new_size, validated_at: Time.current)
  rescue StandardError => e
    package.block! e.message
  end

  private

  def get_attachment_size(url, redirect_count = 0)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 5
    http.read_timeout = 5
    if uri.instance_of?(URI::HTTPS)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    else
      raise I18n.t("errors.messages.url_is_not_https")
    end
    response = http.head(uri.path, { 'User-Agent': USER_AGENT, 'Accept': "application/*" })
    if response.is_a?(Net::HTTPRedirection) && redirect_count < 10
      get_attachment_size(response["location"], redirect_count + 1)
    elsif response.is_a?(Net::HTTPSuccess) &&
          response.content_type.split("/")[0] == "application" &&
          response.content_length > 0
      response.content_length
    else
      raise I18n.t("errors.messages.url_is_not_attachment")
    end
  end
end
