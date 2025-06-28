FactoryBot.define do
  factory :seichi_memo do
    title { "title" }
    body  { "body" }

    # アソシエーション
    association :user
    association :anime
    association :place
  end
end
