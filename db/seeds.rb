# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

case Rails.env
when 'development'
  #Group.create name: 'test'
  u =
    User.create name: 'Eldar',
                username: 'deadalice',
                email: 'eldar.avatov@gmail.com',
                password: '111111'
  User.create name: 'Test',
              username: 'test',
              email: 'test@example.com',
              password: '123456'
  puts Package.create(
         [
           {
             name: 'openssl-1_0',
             alias: 'openssl',
             trusted: true,
             user: u,
             group_name: 'Test',
             external_url: 'https://www.heidisql.com/installers/HeidiSQL_11.0.0.5919_Setup.exe'
           },
           { name: 'openssl-1_1', user: u, group_name: 'Test' },
           { name: 'openssl-1_2', user: u },
           { name: 'openssl-dev', alias: 'openssl-dev', user: u, group_name: 'Test', trusted: true }
         ]
       )
  Package.first.dependencies << Package.last
  Package.last.dependencies << Package.find_by(name: 'openssl-1_1')

  #Package.last.sources.create.attach(io: File.open('files/hqdefault.jpg'), filename: 'hqdefault.jpg')
  Package.first.icon.attach(io: File.open('files/hqdefault.jpg'), filename: 'hqdefault.jpg')
  #Endpoint.create name: 'Test2', user: u, id: '253307f5-0e4f-4a76-9b04-da35ba6345d5'
  #Endpoint.create name: 'Test5', user: User.last
end
