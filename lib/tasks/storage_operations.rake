namespace :sources do
  namespace :empty do
    desc "Erase empty sources from database"
    task clear: :environment do
      # TODO: Clear orphaned components
      Source.where(active_storage_attachments: { record_id: nil }).destroy_all
    end
  end
end
