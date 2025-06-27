FactoryBot.define do
  factory :user do
    username { "test" }
    sequence(:email) { |n| "#{n}@example.com" }
    password { "password" }
  end
end
