namespace :db do
  desc "Provide DB vacuum for production environment"
  task vacuum: :environment do
    tables = ActiveRecord::Base.connection.tables
    tables.each do |table|
      ActiveRecord::Base.connection.execute("VACUUM FULL ANALYZE #{table};")
    end
  end

  desc "Provide DB reindex for production environment"
  task reindex: :environment do
    tables = ActiveRecord::Base.connection.tables
    tables.each do |table|
      ActiveRecord::Base.connection.execute("REINDEX TABLE #{table};")
    end
  end

  namespace :sessions do
    desc "Trim outdated session records"
    task trim: :environment do
      ActiveRecord::SessionStore::Session.delete_by(updated_at: ..(Time.current - ENDPOINT_SESSION_TIME))
    end
  end

  namespace :sources do
    desc "Trim empty sources"
    task trim: :environment do
      # TODO: Clear orphaned components, notify users
      Source.where(active_storage_attachments: { record_id: nil }).destroy_all
    end
  end
end
