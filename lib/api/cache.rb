module Api::Cache
  def cached_endpoint(id, token)
    cache_fetch(Endpoint, id, token)
  end

  def cached_user(id, token)
    cache_fetch(User, id, token)
  end

  private

  def cache_fetch(model, id, token)
    cached_model = model.fetch(id)
    if cached_model&.authentication_token == token && !cached_model&.blocked?
      cached_model
    end
  end
end
