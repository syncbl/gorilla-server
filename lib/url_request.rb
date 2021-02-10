module UrlRequest
  require "net/http"
  require "uri"

  class << self
    def get_content_length(url, redirect_count = 0)
      # TODO: I18n, consts, UA
      raise ArgumentError, "HTTP redirect too deep" unless redirect_count < 10
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.open_timeout = 5
      http.read_timeout = 5
      if uri.instance_of?(URI::HTTPS)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      response = http.head(uri.path, { 'User-Agent': "Test", 'Accept': "*/*" })
      case response
      when Net::HTTPSuccess
        response["content-length"].to_i
      when Net::HTTPRedirection
        self.get_content_length(response["location"], redirect_count + 1)
      end
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
           Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError
      return -1
    end
  end
end
