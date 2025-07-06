FactoryBot.define do
  factory :place do
    sequence(:name) { |n| "name#{n}" }
    address { "東京都千代田区" }
    postal_code { "100-0001" }
    latitude { 35.6895 }
    longitude { 139.6917 }
  end
end
