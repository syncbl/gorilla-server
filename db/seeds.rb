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
  u1 = User.create fullname: "Eldar",
                   name: "deadalice",
                   email: "eldar.avatov@gmail.com",
                   password: "111111"
  u2 = User.create fullname: "Test",
                   name: "tester",
                   email: "tester@example.com",
                   password: "123456"
  puts Package.create(
    [
      {
        name: "openssl-1_0",
        validated_at: Time.current,
        published_at: Time.current,
        user: u1,
        external_url: "https://www.heidisql.com/installers/HeidiSQL_11.0.0.5919_Setup.exe",
      },
      { name: "Openssl-1_1", user: u1 },
      { name: "Openssl-1_2", user: u1 },
      {
        name: "Openssl-2_0",
        user: u2,
        external_url: "https://www.7-zip.org/a/7z1900-x64.exe",
        validated_at: Time.current,
        published_at: Time.current,
      },
      { name: "openssl-2_1", user: u2 },
      { name: "openssl-dev", user: u1 },
    ]
  )
  Package.first.dependencies << Package.last
  Package.last.dependencies << Package.find_by(name: "openssl-1_1")
  CheckExternalUrlJob.perform_now Package.first
  AttachmentService.call Package.last.sources.create, "files/test.zip"
  Package.first.icon.attach(io: File.open("files/hqdefault.jpg"), filename: "hqdefault.jpg")
  Endpoint.create name: "Test2", user: u1, id: "253307f5-0e4f-4a76-9b04-da35ba6345d5"
  e = Endpoint.create name: "Test5", user: User.last
  e.packages << Package.second
end
