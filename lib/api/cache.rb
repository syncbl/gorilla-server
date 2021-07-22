module Api::Cache
  def cached_endpoint(id, token)
    cache_fetch(Endpoint, id, token)
  end

  def cached_user(id, token)
    cache_fetch(User, id, token)
  end

  private

  def cache_fetch(model, id, token)
    cached_model = Rails.cache.fetch(
      "#{model.name}_#{id}",
      expires_in: MODEL_CACHE_TIMEOUT,
    ) do
      model.except_blocked.find_by(
        id: id,
      )
    end
    cached_model if cached_model&.authentication_token == token
  end
end
