FactoryBot.define do
  factory :seichi_memo do
    title { "title" }
    body  { "body" }
    scene_image { nil }
    seichi_photo { nil }

    # アソシエーション
    association :user
    association :anime
    association :place
  end
end
