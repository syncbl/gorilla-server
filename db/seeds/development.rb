return unless Rails.env.development?

u1 =
  User.create fullname: "Eldar Avatov",
              name: "deadalice",
              email: "eldar.avatov@gmail.com",
              password: "111111",
              plan: :pro
u2 =
  User.create fullname: "Test Test",
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
      short_description: "Test package",
      user: u1,
      external_url: "https://www.heidisql.com/installers/HeidiSQL_11.0.0.5919_Setup.exe",
    },
    {
      name: "Openssl-2_0",
      caption: "Test2",
      short_description: "Test package",
      user: u1,
      external_url: "https://www.7-zip.org/a/7z1900-x64.exe",
    },
  ],
)

puts Package::Component.create(
  [
    {
      name: "Openssl-1_1",
      caption: "Test3",
      short_description: "Test",
      description: "Test packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest package",
      user: u1,
      path: "TEST",
    },
    {
      name: "Openssl-1_2",
      caption: "Test4",
      short_description: "Test",
      description: "Test packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest package",
      user: u1,
      path: "TEST",
    },
    {
      name: "Openssl-1_3",
      caption: "Test4",
      short_description: "Test",
      description: "Test packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest package",
      user: u1,
      path: "TEST",
    },
    {
      name: "openssl-2_1",
      caption: "Test5",
      short_description: "Test",
      description: "Test packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest package",
      user: u1,
      path: "TEST",
    },
  ],
)

puts Package::Bundle.create(
  [
    {
      name: "openssl-dev",
      caption: "Test6",
      short_description: "Test",
      description: "Test packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest package",
      user: u1,
      root: :system_root,
      path: "TEST1",
    },
    {
      name: "openssl-dev-2",
      caption: "Test7",
      short_description: "Test",
      description: "Test packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest packageTest package",
      user: u1,
      root: :system_root,
      path: "TEST1",

    },
  ],
)

c = Category.create(caption: "Test")

p = Package::Bundle.find_by(name: "openssl-dev")
# p.dependent_packages << Package.find_by(name: "openssl-1_0")
p.dependent_packages << Package.find_by(name: "openssl-1_1")
p.dependencies.last.update(optional: true, category: c)
p.dependent_packages << Package.find_by(name: "openssl-1_2")
p.dependencies.last.update(optional: false, category: c)
p.dependent_packages << Package.find_by(name: "openssl-1_3")
p.dependencies.last.update(optional: true, category: c)
Product.create(package: p)

Package::Bundle.first.icon.attach(
  io: File.open("files/hqdefault.jpg"),
  filename: "hqdefault.jpg",
)

p = Package::Component.find_by(name: "openssl-1_2")
s =
  p.sources.create(version: "1.0.1",
                   caption: "Test",
                   description: "Test update 1")
FileUtils.cp("files/test1.zip", "tmp")
AttachmentService.call s, "tmp/test1.zip"
File.delete("tmp/test1.zip")

p.add_params_link(
  "anyconnect-win-3.1.05187-web-deploy-k9.exe",
  '{DESKTOP}\Test.lnk',
)
p.add_params_requirement("registry", "test")
s.publish!
s =
  p.sources.create(version: "1.0.2",
                   caption: "Test",
                   description: "Test update 2")
FileUtils.cp("files/test2.zip", "tmp")
AttachmentService.call s, "tmp/test2.zip"
File.delete("tmp/test2.zip")
s.publish!
p.sources.first.update(partial: true)

p1 = Package.last

# s = p1.sources.create(size: 1000, description: "Test update BAD")
# AttachmentService.call s, "files/zbsm.zip"
# s.publish!
p2 = Package.find_by(name: "Openssl-2_1")
p1.dependent_packages << p2
p.dependent_packages << p2
p.publish!

Endpoint.create name: "Test2",
                user: u1,
                id: "253307f5-0e4f-4a76-9b04-da35ba6345d5"
e = Endpoint.create name: "Test5", user: User.last
# TODO: To tests
e.packages << Package::Bundle.find_by(name: "openssl-dev")
