FactoryBot.define do
  factory :session, class: "Session" do
    session_id { SecureRandom.uuid }
    data { { "foo" => "bar" } }
  end
end
