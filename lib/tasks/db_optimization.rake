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
end
