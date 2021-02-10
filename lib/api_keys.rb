module ApiKeys
  # TODO: Move to separate class/module

  class << self
    def app_key(path)
      "#{File.basename(path)}:#{Digest::MD5.file(path).base64digest}"
    end

    def app_keys
      @_app_keys ||= Set[app_key("files/hqdefault.jpg")]
      @_app_keys << "@@" if Rails.env.development?
    end

    def service_keys
      # TODO: Add dictionary of available services
      @_service_keys ||= Set[app_key("files/hqdefault.jpg")]
      @_service_keys << "@@" if Rails.env.development?
    end

    def anonymous_keys
      # TODO: Add dictionary of available services
      @_anonymous_keys ||= Set[app_key("files/hqdefault.jpg")]
      @_anonymous_keys << "@@" if Rails.env.development?
    end

    # TODO: Clear keys when new version added
    def clear_keys
      @_app_keys = nil
      @_service_keys = nil
      @_anonymous_keys = nil
    end
  end
end
