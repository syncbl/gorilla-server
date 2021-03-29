module UrlRequest
  require "net/http"
  require "uri"

  # TODO: https://zetcode.com/ruby/httpclient/

  USER_AGENT = "Syncable Server/1.0 https://syncbl.com"

  class << self
    def get_attachment_size(url, redirect_count = 0)
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.open_timeout = 5
      http.read_timeout = 5
      if uri.instance_of?(URI::HTTPS)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      response = http.head(uri.path, { 'User-Agent': USER_AGENT, 'Accept': "*/*" })
      if response.is_a?(Net::HTTPRedirection) && redirect_count < 10
        self.get_attachment_size(response["location"], redirect_count + 1)
      elsif response.is_a?(Net::HTTPSuccess) && response["Content-Disposition"].present? &&
            response["Content-Disposition"].split(";")[0].downcase == "attachment"
        response["content-length"].to_i
      end
    end
  end
end
