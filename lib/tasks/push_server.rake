namespace :push do
  desc "Run push server on default port"
  task server: :environment do
    Push::Server.new.run!
  end
end
