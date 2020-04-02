# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

case Rails.env
when "development"
  Company.create name: 'Test'
  User.create name: 'Eldar', email: 'eldar.avatov@gmail.com', password: '111111'
  User.create name: 'Test', email: 'test@example.com', password: '123456'
  Package.create([{name: 'openssl-1_0', alias: 'openssl', trusted: true, user: User.first},
  {name: 'openssl-1_1'}, {name: 'openssl-1_2'}, {name: 'openssl-1_3'},
  {name: 'openssl-1_4'}, {name: 'openssl-1_5', user: User.first}, {name: 'openssl-1_6'},
  {name: 'openssl-1_7'}, {name: 'openssl-dev', trusted: true}])
  Package.first.dependencies << Package.last
  Package.last.dependencies << Package.find_by(name: 'openssl-1_5')
  #Package.first.files.attach(io: File.open('storage/README.md'), filename: 'README.md')
  Endpoint.create name: 'Test', user: User.last
  Endpoint.create name: 'Test2', user: User.first, id: '253307f5-0e4f-4a76-9b04-da35ba6345d5'
end
