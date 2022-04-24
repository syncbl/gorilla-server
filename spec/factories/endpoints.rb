FactoryBot.define do
  factory :endpoint1, class: "Endpoint" do
    # We should not use factory here, because it will create a user
    # user factory: :user1
    caption { "endpoint1" }
  end
end
