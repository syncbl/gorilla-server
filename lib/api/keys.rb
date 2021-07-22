class Api::Keys
  class << self
    def user
      @_user_keys ||= Set[app_key("files/hqdefault.jpg")]
      @_user_keys << "@user@" if Rails.env.development?
    end

    def endpoint
      # TODO: Add dictionary of available services
      @_endpoint_keys ||= Set[app_key("files/hqdefault.jpg")]
      @_endpoint_keys << "@endpoint@" if Rails.env.development?
    end

    def anonymous
      # TODO: Add dictionary of available services
      @_anonymous_keys ||= Set[app_key("files/hqdefault.jpg")]
      @_anonymous_keys << "@@" if Rails.env.development?
    end

    # TODO: Clear keys when new version added
    def clear_keys
      @_user_keys = nil
      @_endpoint_keys = nil
      @_anonymous_keys = nil
    end

    private

    def app_key(path)
      "#{File.basename(path)}:#{Digest::MD5.file(path).hexdigest}"
    end
  end
end
