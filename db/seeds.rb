# db/seeds.rb

# 作品ジャンルタグの作成

# 作品ジャンル一覧
genre_names = [
  "アクション/バトル", "SF/ファンタジー", "恋愛/ラブコメ",
  "コメディ/ギャグ", "日常/ほのぼの", "スポーツ/競技", "ホラー/サスペンス",
  "ミステリー/推理", "歴史/時代劇", "ドラマ/青春", "音楽/アイドル",
  "アドベンチャー/冒険", "ロボット/メカ", "バトルロイヤル/サバイバル",
  "戦記/ミリタリー",  "キッズ/ファミリー", "異世界", "冒険", "異能", "学園"
]
# ジャンルタグを重複なく作成
genre_names.each do |name|
  GenreTag.find_or_create_by!(name: name)
end

puts "✅ #{genre_names.size}件のジャンルタグを登録しました。"

puts "🔧 counter_culture実行中..."
Like.counter_culture_fix_counts
puts "✅ likes_count 修正完了！"
