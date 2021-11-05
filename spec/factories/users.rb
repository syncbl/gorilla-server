FactoryBot.define do
  factory :user1, class: User do
    fullname { "Test1 Test1" }
    name { "user1" }
    email { "user1@example.com" }
    password { "123456" }
    disclaimer { "Test1" }
    plan { :personal }
  end

  factory :user2, class: User do
    fullname { "Test2 Test2" }
    name { "user2" }
    email { "user2@example.com" }
    password { "123456" }
    disclaimer { "Test2" }
    plan { :personal }
  end
end
