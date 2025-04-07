namespace :carrierwave do
  desc "キャッシュされた画像を削除する"
  task clean_tmp: :environment do
    CarrierWave.clean_cached_files!
    puts "✨ キャッシュされた画像を削除しました！"
  end
end
