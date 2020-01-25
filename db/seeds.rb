# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

case Rails.env
when "development"
  User.create name: 'Test', email: 'test@example.com', password: '123456'
  #User.create email: 'eldar.avatov@gmail.com', encrypted_password: '$2a$11$taCALJiHs0S09Pgu.WKZ8.trzmtyEpXm5DWKoN/mdkRzEYZzNkP2e',
  #  authentication_token: 'Tfu_P5XZyCpZxkrXpNfh'
  Package.create name: 'openssl-1.0.3', alias: 'openssl', key: 'e751b48e-d95e-4a95-91fd-fa54a2ec8860', trusted: true
  Package.create name: 'openssl-1.0.1'
  Package.create name: 'openssl-dev', trusted: true
  Package.first.dependencies << Package.last
  Package.first.files.attach(io: File.open('storage/README.md'),
    filename: 'README.md')
  Endpoint.create name: 'test', key: '22c10457-3905-4bd6-bcdd-95349fe3ab45', user: User.first
end
