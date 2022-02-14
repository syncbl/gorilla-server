FactoryBot.define do
  factory :user1, class: 'User' do
    fullname { "Test1 Test1" }
    name { "user1" }
    email { "user1@example.com" }
    password { "123456" }
    plan { :pro }

    after :create do |user|
      user.subscriptions.create
    end
  end

  factory :user2, class: 'User' do
    fullname { "Test2 Test2" }
    name { "user2" }
    email { "user2@example.com" }
    password { "123456" }
    plan { :personal }

    after :create do |user|
      user.subscriptions.create
    end
  end
end
