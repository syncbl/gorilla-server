source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.0"

# Core
gem "rails", "~> 7" # Ruby on Rails is a full-stack web framework.
gem "net-smtp", require: false # Rails 7 error workaround
gem "rails-i18n", "~> 7" # Centralization of locale data collection for Ruby on Rails.
gem "puma", "~> 5.5" # Puma is a simple, fast, multi-threaded, and highly concurrent HTTP 1.1 server for Ruby/Rack applications.
gem "bootsnap", ">= 1.4.2", require: false # Boot large ruby/rails apps faster.
gem "turbolinks", "~> 5.0" # Turbolinks makes following links in your web application faster (use with Rails Asset Pipeline).
gem "sprockets-rails" # Provides Sprockets implementation for Rails 4.x (and beyond) Asset Pipeline.
gem "importmap-rails" # Import maps let you import JavaScript modules using logical names that map to versioned/digested files.
gem "sass-rails" # This gem provides official integration for Ruby on Rails projects with the Sass stylesheet language.
gem "turbo-rails" # Turbo gives you the speed of a single-page web application without having to write any JavaScript.
gem "view_component" # A framework for creating reusable, testable & encapsulated view components

# Database
gem "pg", "~> 1" # Pg is the Ruby interface to the PostgreSQL RDBMS.
gem "pg_search" # PgSearch builds named scopes that take advantage of PostgreSQL's full text search.
gem "redis" # A Ruby client that tries to match Redis' API one-to-one.
gem "hiredis" # Ruby extension that wraps hiredis.

# Other
gem "activerecord-session_store" # A session store backed by an Active Record class.
# gem "activerecord-summarize" # Summarize your ActiveRecord models.
gem "active_record-events" # An ActiveRecord extension providing convenience methods for timestamp management.
gem "active_storage_validations" # Active Storage Validations.
# gem "acts-as-taggable-on" # ActsAsTaggableOn is a library for managing tags on ActiveRecord models.
gem "aws-sdk-s3", require: false # Official AWS Ruby gem for Amazon Simple Storage Service (Amazon S3)
gem "bcrypt" # Provides a simple wrapper for safely handling passwords.
# gem "bootstrap", "~> 4.6.0" # Bootstrap ruby gem for Ruby on Rails.
gem "cancancan" # Authorization library for Ruby and Ruby on Rails
gem "cityhash" # For faster hashing (C-Ruby only)
gem "clamby" # This gem's function is to simply scan a given file.
gem "dalli" # To use :mem_cache_store
gem "devise" # Devise is a flexible authentication solution for Rails based on Warden.
gem "devise-i18n" # Devise I18n.
gem "devise-bootstrap5" # Devise Bootstrap5.
# gem "discard" # Soft deletes for ActiveRecord done right.
gem "enumerize" # Enumerated attributes with I18n and ActiveRecord/Mongoid/MongoMapper/Sequel support
gem "eventmachine" # EventMachine is an event-driven I/O and lightweight concurrency library for Ruby.
gem "goldiloader" # ActiveRecord eager loading
# gem "has_friendship" # A simple friendship management gem for Rails.
gem "high_voltage" # Rails engine for static pages.
# gem "hotwire-rails" # Hotwire is an alternative approach to building modern web applications without using much JavaScript.
gem "http_accept_language" # Detect the users preferred language, as sent by the "Accept-Language" HTTP header.
gem "identity_cache" # Opt in read through ActiveRecord caching used in production and extracted from Shopify.
gem "jb" # A simpler and faster Jbuilder alternative.
gem "json_translate" # Rails I18n library for ActiveRecord model/data translation
gem "jsonb_accessor", "~> 1" # Adds typed jsonb backed fields as first class citizens to your ActiveRecord models.
gem "jwt" # A ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard.
# gem "metainspector" # A Ruby library for extracting meta data from HTML pages.
# gem "noticed" # Notifications for your Ruby on Rails app.
# gem "omniauth" # Standardized Multi-Provider Authentication.
gem "pagy", "~> 3.8" # Pagination gem that outperforms the others in each and every benchmark and comparison.
gem "rack-attack" # Rack middleware for blocking & throttling abusive requests.
# gem "render_async" # Pages become faster seamlessly by rendering partials to your views.
gem "rubyzip", require: "zip" # Ruby library for reading and writing zip files.
gem "ruby-progressbar" # The ultimate text progress bar library for Ruby!
# gem "scenic" # Scenic adds methods to ActiveRecord::Migration to create and manage database views in Rails.
gem "simple_form" # Simple Form aims to be as flexible as possible while helping you with powerful components to create your forms.
gem "strip_attributes" # Automatically strips all attributes of leading and trailing whitespace before validation.
gem "uglifier" # Ruby wrapper for UglifyJS JavaScript compressor.

group :development, :test do
  gem "simplecov", require: false # A simple Ruby coverage tool.
  gem "rspec-rails" # RSpec Rails is a Ruby extension for writing tests for Rails applications.
  gem "factory_bot_rails" # FactoryBot is a Ruby library for generating test data for use with Rails and should be
  gem "capybara" # Capybara is a test framework for integration testing of web applications.
  gem "database_cleaner" # Database cleaner is a gem for testing that cleans your database before and after each test.
  gem "shoulda-matchers" # Shoulda-Matchers is a set of matchers for test cases.
  gem "rspec-json_expectations" # RSpec matcher for JSON.
  gem "debug", ">= 1.0.0" # Ruby debugging tool
  gem "bundler-audit" # Audit your Gemfile and Gemfile.lock
  gem "brakeman" # Ruby on Rails vulnerability scanner.
end

group :development do
  gem "listen" # Listen is a simple and powerful event-based server for Ruby.
  gem "spring" # Spring speeds up development by keeping your application running in the background.
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "awesome_print", require: "ap" # A better, more colorful, printer for Ruby objects.
  gem "better_errors" # Better Errors is a drop-in replacement for Rails' default error pages.
  gem "binding_of_caller" # Provides a binding.of_caller method for the REPL.
  gem "derailed_benchmarks" # Benchmarking framework for Ruby.
  gem "i18n-tasks" # I18n tasks for rails
  gem "bullet" # Bullet enables Bullet to detect N+1 queries and improve your application.
  gem "query_count" # Query count for ActiveRecord
  gem "traceroute" # A simple Ruby library for tracing the route of a request.
  gem "rack-mini-profiler" # Rack middleware for profiling Rails applications.
  gem "memory_profiler" # Memory Profiler is a Ruby library for profiling memory usage.
  gem "rails_best_practices" # A collection of best practices for Rails apps.
  gem "rubocop" # Ruby style guide checker
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem 'rubocop-performance', require: false
  gem "solargraph" # A Ruby language server for the Ruby language.
  gem "rufo" # Ruby source code analyzer
  gem "reek" # Ruby code smells detector
end

group :production do
  gem "whenever", require: false # Provides a clear syntax for writing and deploying cron jobs.
  gem "connection_pool" # Connection pooling for ActiveRecord.
end
