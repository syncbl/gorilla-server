namespace :sources do
  namespace :empty do
    desc "Erase empty sources from database"
    task clear: :environment do
      Source.empty do |source|
        source.destroy
      end
    end
  end
end