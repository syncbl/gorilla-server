module Api
  module Cache
    def cached_endpoint(id, token)
      endpoint = cache_fetch(Endpoint, id, token)
      raise Pundit::NotAuthorizedError unless endpoint

      endpoint
    end

    def cached_user(id, token)
      user = cache_fetch(User, id, token)
      raise Pundit::NotAuthorizedError unless user

      user
    end

    # TODO: Avoid using local variable here, consider using session!
    def current_endpoint
      @sign_in_endpoint
    end

    def sign_in_endpoint(endpoint)
      @sign_in_endpoint ||= endpoint
    end

    private

    def cache_fetch(model, id, token)
      cached_model = model.fetch(id)
      if ActiveSupport::SecurityUtils.secure_compare(cached_model&.authentication_token, token) &&
         !cached_model&.blocked?
        cached_model
      end
    end
  end
end
