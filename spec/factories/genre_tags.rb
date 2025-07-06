FactoryBot.define do
  factory :genre_tag do
    name { "ジャンル名" }

    trait :action_battle do
      name { "アクション/バトル" }
    end

    trait :sf_fantasy do
      name { "SF/ファンタジー" }
    end

    trait :romance do
      name { "恋愛/ラブコメ" }
    end

    trait :comedy do
      name { "コメディ/ギャグ" }
    end
    trait :slice_of_life do
      name { "日常/ほのぼの" }
    end

    trait :sports do
      name { "スポーツ/競技" }
    end

    trait :horror do
      name { "ホラー/サスペンス" }
    end

    trait :mystery do
      name { "ミステリー/推理" }
    end

    trait :history do
      name { "歴史/時代劇" }
    end

    trait :drama do
      name { "ドラマ/青春" }
    end

    trait :music do
      name { "音楽/アイドル" }
    end

    trait :adventure do
      name { "アドベンチャー/冒険" }
    end

    trait :mecha do
      name { "ロボット/メカ" }
    end

    trait :battle_royale do
      ame { "バトルロイヤル/サバイバル" }
    end

    trait :military do
      name { "戦記/ミリタリー" }
    end

    trait :kids do
      name { "キッズ/ファミリー" }
    end

    trait :isekai do
      name { "異世界" }
    end

    trait :boken do
      name { "冒険" }
    end

    trait :power do
      name { "異能" }
    end

    trait :school do
      name { "学園" }
    end
  end
end
