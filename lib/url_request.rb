module UrlRequest
  require "net/http"
  require "uri"

  class << self
    def get_content_length(url, redirect_count = 0)
      # TODO: UA and Accept
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.open_timeout = 5
      http.read_timeout = 5
      if uri.instance_of?(URI::HTTPS)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      response = http.head(uri.path, { 'User-Agent': "Test", 'Accept': "*/*" })
      if response == Net::HTTPRedirection && redirect_count < 10
        self.get_content_length(response["location"], redirect_count + 1)
      elsif response == Net::HTTPSuccess && response["Content-Disposition"] &&
            response["Content-Disposition"].split(";")[0].downcase == "attachment"
        response["content-length"].to_i
      else
        -1
      end
    end
  end
end
