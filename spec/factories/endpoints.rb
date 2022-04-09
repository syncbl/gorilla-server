FactoryBot.define do
  factory :endpoint1, class: "Endpoint" do
    user factory: :user1
    name { "endpoint1" }
  end
end
