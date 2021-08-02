IdentityCache.cache_backend = ActiveSupport::Cache.lookup_store(*Rails.configuration.identity_cache_store)
IdentityCache.fetch_read_only_records = false
