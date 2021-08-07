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
        caption: "Test1",
        description: "Test package",
        user: u1,
        external_url: "https://www.heidisql.com/installers/HeidiSQL_11.0.0.5919_Setup.exe",
        path: 'D:\TEST',
      },
      {
        name: "Openssl-2_0",
        caption: "Test2",
        description: "Test package",
        user: u2,
        external_url: "https://www.7-zip.org/a/7z1900-x64.exe",
        path: 'D:\TEST',
      },
    ]
  )

  puts Package::Component.create(
    [
      { name: "Openssl-1_1", caption: "Test3",
        description: "Test packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest package",
        user: u1,
        path: 'D:\TEST' },
      { name: "Openssl-1_2", caption: "Test4",
        description: "Test packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest package",
        user: u1,
        path: 'D:\TEST' },
      { name: "openssl-2_1", caption: "Test5",
        description: "Test package",
        user: u2,
        path: 'D:\TEST' },
    ]
  )

  puts Package::Bundle.create(
    [
      { name: "openssl-dev", caption: "Test6",
        description: "Test package",
        user: u1,
        path: 'D:\TEST' },
      { name: "openssl-dev-2", caption: "Test7",
        description: "Test package",
        user: u1,
        path: 'D:\TEST' },
    ]
  )

  Package::Bundle.first.icon.attach(io: File.open("files/hqdefault.jpg"),
                                    filename: "hqdefault.jpg")

  p = Package::Bundle.find_by(name: "openssl-dev")
  s = p.sources.create(size: 1000, version: "1.0.0", description: "Test update 1")
  AttachmentService.call s, "files/test1.zip"
  p.add_params_link("anyconnect-win-3.1.05187-web-deploy-k9.exe",
                  '{DESKTOP}\Test.lnk')
  p.add_params_requirement("registry",
                         "test")
  s.validate!
  s.publish!
  s = p.sources.create(size: 1000, version: "1.0.0", description: "Test update 2")
  AttachmentService.call s, "files/test2.zip"
  s.validate!
  s.publish!
  # p.dependent_packages << Package.find_by(name: "openssl-1_0")
  p.dependent_packages << Package.find_by(name: "openssl-1_1")
  p.dependencies.last.update(is_optional: true)
  p.dependent_packages << Package.find_by(name: "openssl-1_2")
  p.dependencies.last.update(is_optional: true)
  Product.create(package: p, validated_at: Time.current)

  p1 = Package.last
  # s = p1.sources.create(size: 1000, description: "Test update BAD")
  # AttachmentService.call s, "files/zbsm.zip"
  # s.validate!
  # s.publish!
  p2 = Package.find_by(name: "Openssl-2_1")
  p2.maintainers << u1
  p1.dependent_packages << p2
  p.dependent_packages << p2
  p.validate!
  p.publish!

  p3 = Package.find_by(name: "Openssl-2_0")
  p3.maintainers << u1

  Endpoint.create name: "Test2", user: u1, id: "253307f5-0e4f-4a76-9b04-da35ba6345d5"
  e = Endpoint.create name: "Test5", user: User.last
  e.packages << p
end
