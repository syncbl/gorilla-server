require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GpServer
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.enable_dependency_loading = true
    config.autoload_paths += %W[#{config.root}/lib]
    config.i18n.enforce_available_locales = false
    config.i18n.available_locales = %i[ru en]
    config.i18n.default_locale = :ru
    config.i18n.fallbacks = [config.i18n.default_locale]
  end
end
