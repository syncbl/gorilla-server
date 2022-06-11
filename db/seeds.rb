# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# rubocop:disable Style/MultilineBlockChain
begin
  load(Rails.root.join("db", "seeds", "#{Rails.env.downcase}.rb"))
rescue StandardError => e
  Rails.logger.debug e.to_s.strip
  Rails.logger.debug e.backtrace.map do |x|
         x =~ /^(.+?):(\d+)(|:in `(.+)')$/
         [Regexp.last_match(1), Regexp.last_match(2)]
       end.reject { |x| x[0].include? ".rvm" }
  exit 1
end
# rubocop:enable Style/MultilineBlockChain
