class CheckExternalUrlJob < ApplicationJob
  require "net/http"
  require "uri"
  require "timeout"

  queue_as :default

  def perform(package)
    Timeout::timeout(JOB_TIMEOUT) do
      if package.external_url.present?
        new_size = get_attachment_size(package.external_url).to_i
        package.update(size: new_size, validated_at: Time.current)
      end
    rescue StandardError => e
      package.block! e.message
      # TODO: Log e with url
    end
  rescue Timeout::Error
    source.block! "+++ TIMEOUT +++"
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
      raise I18n.t('model.package.error.url_is_not_https')
    end
    response = http.head(uri.path, { 'User-Agent': USER_AGENT, 'Accept': "*/*" })
    if response.is_a?(Net::HTTPRedirection) && redirect_count < 10
      get_attachment_size(response["location"], redirect_count + 1)
    elsif response.is_a?(Net::HTTPSuccess) && response["Content-Disposition"].present? &&
          response["Content-Disposition"].split(";")[0].downcase == "attachment"
      response["content-length"].to_i
    else
      raise I18n.t('model.package.error.url_is_not_attachment')
    end
  end
end
