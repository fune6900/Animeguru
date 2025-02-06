user = User.first || User.create!(email: "test@example.com", password: "password", username: "TestUser")

animes = Anime.create!([
  { title: "進撃の巨人", official_site_url: "https://shingeki.tv/" },
  { title: "鬼滅の刃", official_site_url: "https://kimetsu.com/" },
  { title: "涼宮ハルヒの憂鬱", official_site_url: "https://haruhi.tv/" },
  { title: "ラブライブ！", official_site_url: "https://lovelive-anime.jp/" },
  { title: "ゆるキャン△", official_site_url: "https://yurucamp.jp/" }
])

places = Place.create!([
  { name: "長野県上田市", address: "長野県上田市", postal_code: "386-0012" },
  { name: "富士山", address: "静岡県・山梨県", postal_code: "403-0000" },
  { name: "京都府嵐山", address: "京都府京都市右京区", postal_code: "616-0000" },
  { name: "秋葉原", address: "東京都千代田区外神田", postal_code: "101-0021" },
  { name: "山梨県本栖湖", address: "山梨県南都留郡", postal_code: "401-0337" }
])

25.times do
  SeichiMemo.create!(
    user: user,
    anime: animes.sample,
    place: places.sample,
    title: Faker::Lorem.characters(number: 20),
    body: Faker::Lorem.paragraph_by_chars(number: 900)
  )
end

puts "✅ SeichiMemosのシードデータ 25件 作成完了！"
