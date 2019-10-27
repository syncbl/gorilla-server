# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

case Rails.env
when "development"
  User.create username: 'test1'
  User.create username: 'test2'
  p = Package.create name: 'openssl-1.0.3', alias: 'openssl'
  Package.create name: 'openssl-1.0.1'
  Product.create title: 'OpenSSL', package: p
  Endpoint.create name: 'test', user: User.first
end
