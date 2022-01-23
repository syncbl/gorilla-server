FactoryBot.define do
  factory :component1, class: Package::Component do
    name { "component1" }
    caption { "Component 1" }
    short_description { "Test" }
    description { "Test package" }
    path { "TEST1" }
  end

  factory :component2, class: Package::Component do
    name { "component2" }
    caption { "Component 2" }
    short_description { "Test" }
    description { "Test package" }
    path { "TEST1" }
  end

  factory :bundle1, class: Package::Bundle do
    name { "bundle1" }
    caption { "Bundle 1" }
    short_description { "Test" }
    description { "Test package" }
    root { :system_root }
    path { "TEST1" }
  end

  factory :bundle2, class: Package::Bundle do
    name { "bundle2" }
    caption { "Bundle 2" }
    short_description { "Test" }
    description { "Test package" }
    root { :system_root }
    path { "TEST1" }
  end

  factory :external1, class: Package::External do
    name { "external1" }
    caption { "External 1" }
    short_description { "Test" }
    description { "Test package" }
    external_url { "https://www.heidisql.com/installers/HeidiSQL_11.0.0.5919_Setup.exe" }
  end
end
