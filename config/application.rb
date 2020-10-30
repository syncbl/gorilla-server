require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
#require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
#require "action_cable/engine"
#require "sprockets/railtie"
#require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GpServer
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.enable_dependency_loading = true
    config.autoload_paths += %W[#{config.root}/lib]
    config.i18n.available_locales = %i[en ru]
    config.i18n.default_locale = :en
    config.i18n.fallbacks = [config.i18n.default_locale]
    config.active_storage.routes_prefix = '/'

    # Custom Syncable parameters
    syncable = ActiveSupport::OrderedOptions.new
    syncable.service_path = 'files/hqdefault.jpg'
    syncable.user_token_expiration_time = 1.day
    syncable.endpoint_token_expiration_time = 1.week
    syncable.endpoint_token_regen_random = 10
    syncable.empty_source_erase_after = 1.day
    config.syncable = syncable

    Lockbox.master_key = Rails.application.credentials.lockbox_secret
  end
end
