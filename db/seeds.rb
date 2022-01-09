# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

begin
  load(Rails.root.join("db", "seeds", "#{Rails.env.downcase}.rb"))
  puts "OK"
rescue StandardError => e
  puts e.to_s.strip
  puts e.backtrace.map { |x|
         x.match(/^(.+?):(\d+)(|:in `(.+)')$/)
         [$1, $2]
       }.reject { |x|
         x[0].include? ".rvm"
       }
  exit 1
end
