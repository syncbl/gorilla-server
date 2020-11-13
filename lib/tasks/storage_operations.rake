namespace :sources do
  namespace :empty do
    desc "Erase empty sources from database"
    task clear: :environment do
      Source.joins(:file_attachment)
        .where(external_url: nil, active_storage_attachments: { record_id: nil })
        .map { |s| s.destroy }
    end
  end
end
