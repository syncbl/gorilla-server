require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SyncblServer
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.enable_dependency_loading = true
    config.autoload_paths += %W[#{config.root}/lib]
    config.i18n.available_locales = %i[en]
    config.i18n.default_locale = :en
    config.i18n.fallbacks = [config.i18n.default_locale]
    config.active_storage.routes_prefix = "/files"
    config.active_storage.service_urls_expire_in = 1.hour
    config.identity_cache_store = :mem_cache_store, "localhost", "localhost", {
      expires_in: 6.hours.to_i, # in case of network errors when sending a cache invalidation
      failover: false # avoids more cache consistency issues
    }
    config.session_store :active_record_store,
                         key: Rails.application.credentials.jwt_secret

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
