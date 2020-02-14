# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

case Rails.env
when "development"
  User.create name: 'Test', email: 'test@example.com', password: '123456', company: (Company.create name: 'Test')
  p = Package.create name: 'openssl-1.0.3', alias: 'openssl', trusted: true
  Package.create name: 'openssl-1.0.1'
  Package.create name: 'openssl-dev', trusted: true
  p.dependencies << Package.last
  #p.archive.attach(io: File.open('storage/README.md'), filename: 'README.md')
  Endpoint.create name: 'Test', user: User.first
end
