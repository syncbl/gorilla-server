DatabaseCleaner.strategy = :transaction

RSpec.configure do |config|
  config.around do |example|
    DatabaseCleaner.cleaning { example.run }
  end
end
