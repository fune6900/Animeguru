FactoryBot.define do
  factory :anime do
    sequence(:title) { |n| "title#{n}" }
    official_site_url { "https://example.com" }
    image_url { nil }
  end
end
