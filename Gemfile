source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.2"

# Core
gem "rails", "~> 6.1" # Ruby on Rails is a full-stack web framework.
gem "rails-i18n", "~> 6.0" # Centralization of locale data collection for Ruby on Rails.
gem "puma", "~> 5.1" # Puma is a simple, fast, multi-threaded, and highly concurrent HTTP 1.1 server for Ruby/Rack applications.
gem "bootsnap", ">= 1.4.2", require: false # Boot large ruby/rails apps faster.
gem "rack-attack" # Rack middleware for blocking & throttling abusive requests.

# Javacsript
gem "webpacker", "~> 5.4" # Webpacker makes it easy to use the JavaScript pre-processor.
gem "turbolinks", "~> 5.0" # Turbolinks makes following links in your web application faster (use with Rails Asset Pipeline).
gem "jquery-rails" # JQuery support
gem "uglifier" # Ruby wrapper for UglifyJS JavaScript compressor.

# Database
gem "pg", "~> 1" # Pg is the Ruby interface to the PostgreSQL RDBMS.
gem "pg_search" # PgSearch builds named scopes that take advantage of PostgreSQL's full text search.
gem "redis" # A Ruby client that tries to match Redis' API one-to-one.
gem "hiredis" # Ruby extension that wraps hiredis.

# Other
gem "activerecord-import"
gem "active_storage_validations" # Active Storage Validations.
gem "aws-sdk-s3", require: false # Official AWS Ruby gem for Amazon Simple Storage Service (Amazon S3)
gem "bcrypt" # Provides a simple wrapper for safely handling passwords.
gem "bootstrap", "~> 4.6.0" # Bootstrap ruby gem for Ruby on Rails.
gem "cityhash" # optional, for faster hashing (C-Ruby only)
gem "clamby" # This gem's function is to simply scan a given file.
gem "dalli" # To use :mem_cache_store
gem "devise" # Devise is a flexible authentication solution for Rails based on Warden.
gem "devise_invitable" # Adds support to Devise for sending invitations by email.
gem "devise-bootstrap-views" # Devise views with Bootstrap 4.
#gem "discard" # Soft deletes for ActiveRecord done right.
gem "enumerize" # Enumerated attributes with I18n and ActiveRecord/Mongoid/MongoMapper/Sequel support
gem "goldiloader" # ActiveRecord eager loading
gem "high_voltage" # Rails engine for static pages.
#gem "hotwire-rails" # Hotwire is an alternative approach to building modern web applications without using much JavaScript.
gem "http_accept_language" # Detect the users preferred language, as sent by the "Accept-Language" HTTP header.
gem "identity_cache" # Opt in read through ActiveRecord caching used in production and extracted from Shopify.
gem "jb" # A simpler and faster Jbuilder alternative.
gem "json_translate" # Rails I18n library for ActiveRecord model/data translation
gem "jsonb_accessor", "~> 1" # Adds typed jsonb backed fields as first class citizens to your ActiveRecord models.
gem "jwt" # A ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard.
#gem "omniauth" # Standardized Multi-Provider Authentication.
#gem "noticed" # Notifications for your Ruby on Rails app.
gem "pagy", "~> 3.8" # Pagination gem that outperforms the others in each and every benchmark and comparison.
gem "pundit" # Set of helpers to build an authorization system.
gem "render_async" # Pages become faster seamlessly by rendering partials to your views.
gem "rubyzip", require: "zip" # Ruby library for reading and writing zip files.
#gem "sidekiq" # Simple, efficient background processing for Ruby.
gem "scenic" # Scenic adds methods to ActiveRecord::Migration to create and manage database views in Rails.
gem "simple_form" # Simple Form aims to be as flexible as possible while helping you with powerful components to create your forms.
gem "whenever", require: false # Provides a clear syntax for writing and deploying cron jobs.

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "simplecov", require: false
  gem "rspec-rails", "~> 5.0"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "awesome_print", :require => "ap"
  gem "better_errors"
  gem "binding_of_caller"
  gem "derailed_benchmarks"
  gem "i18n-tasks"
  gem "bullet"
  gem "rufo"
  gem "query_count"
  gem "traceroute"
  gem "rack-mini-profiler"
  gem "memory_profiler"
  gem "rails_best_practices"
end

group :production do
  # Foreman for workers
  #gem "foreman"
  gem "connection_pool"
end
