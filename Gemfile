source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'rails', '~> 6.0'
gem 'rails-i18n', '~> 6.0'
gem 'puma', '~> 4.2'
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'sass-rails', '~> 5'
gem 'webpacker', '~> 4.0'
gem 'turbolinks', '~> 5'
gem 'jquery-rails'
gem 'devise'

gem 'bootstrap', '~> 4.3.1'
gem 'devise-bootstrap-views', '~> 1.0'
#gem 'pagy', '~> 3.5'

# JSON Builder
gem 'jb'
# PostgreSQL will be used for data storage
gem 'pg', '~> 1'
# Redis for cache
gem 'redis', '~> 4.0'
gem 'hiredis'
# S3 buckets for Active Storage
gem 'aws-sdk'

# CRON scheduling
#gem 'whenever', require: false
# HTML parsing for download link detection
#gem "nokogiri"
# String sanitazing
#gem "sanitize"
# Use ActiveStorage variant
#gem 'mini_magick', '~> 4.8'
# Foreman for workers
#gem "foreman"
# Soft delete for all records
gem 'discard', '~> 1.0'
# Stream zip as file container
#gem 'zip_tricks'
# Pack parts to zip
# ???
gem 'rubyzip', require: 'zip'
# Translate packages
#gem 'globalize', '~> 5.1.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'simplecov', require: false
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'awesome_print', :require => 'ap'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
  gem 'memory_profiler'
  gem 'derailed_benchmarks'
  gem 'i18n-tasks', '~> 0.9.30'
end

group :production do
  #gem 'redis', '~> 4.0'
end
