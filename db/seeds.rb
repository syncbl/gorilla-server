# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

case Rails.env
when "development"
  #Group.create name: 'test'
  u1 = User.create fullname: "Eldar Avatov",
                   name: "deadalice",
                   email: "eldar.avatov@gmail.com",
                   password: "111111",
                   plan: :pro
  u2 = User.create fullname: "Test Test",
                   name: "tester",
                   email: "tester@example.com",
                   password: "123456",
                   plan: :personal
  u1.subscriptions.create
  u2.subscriptions.create

  puts Package::External.create(
    [
      {
        name: "openssl-1_0",
        user: u1,
        external_url: "https://www.heidisql.com/installers/HeidiSQL_11.0.0.5919_Setup.exe",
      },
      {
        name: "Openssl-2_0",
        user: u2,
        external_url: "https://www.7-zip.org/a/7z1900-x64.exe",
      },
    ]
  )

  puts Package::Component.create(
    [
      { name: "Openssl-1_1", user: u1 },
      { name: "Openssl-1_2", user: u1 },
      { name: "openssl-2_1", user: u2 },
    ]
  )

  puts Package::Default.create(
    [
      { name: "openssl-dev", user: u1 },
      { name: "openssl-dev-2", user: u1 },
    ]
  )

  Package::Default.first.icon.attach(io: File.open("files/hqdefault.jpg"),
                                     filename: "hqdefault.jpg")

  p = Package.find_by(name: "Openssl-2_0")
  p.validate!
  p.publish!
  Product.create(package: p, validated_at: Time.current)

  p = Package.find_by(name: "openssl-dev")
  s = p.sources.create(size: 1000)
  AttachmentService.call s, "files/test.zip"
  s.validate!
  s.publish!
  Product.create(package: p, validated_at: Time.current)

  p1 = Package.last
  p2 = Package::Component.find_by(name: "Openssl-2_1")
  p2.maintainers << u1
  p1.components << p2

  Endpoint.create name: "Test2", user: u1, id: "253307f5-0e4f-4a76-9b04-da35ba6345d5"
  e = Endpoint.create name: "Test5", user: User.last
  e.packages << Package.second
end
