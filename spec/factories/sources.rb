FactoryBot.define do
  factory :source1, class: "Source" do
    version { "1.0" }
    caption { "Test1" }
    description { "Test 1" }
    file do
      Rack::Test::UploadedFile.new(
        File.open(Rails.root.join("files/test1.zip")),
      )
    end
  end
end
