namespace :sources do
  namespace :empty do
    desc "Erase empty sources from database, once a week"
    task clear: :environment do
      Source.where(Source.arel_table[:updated_at].lt(Time.current - 1.day))
        .where(Source.arel_table[:updated_at].gt(Time.current - 1.week))
        .select { |source| source.undefined? }
        .map { |s| s.destroy }
    end
  end
end
