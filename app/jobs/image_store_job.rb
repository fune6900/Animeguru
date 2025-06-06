class ImageStoreJob < ApplicationJob
  queue_as :default
  
  # このジョブは、CarrierWaveのアップローダーによる `.store!` 処理を
  # 非同期（バックグラウンド）で行うためのジョブ。
  def perform(uploader_cache)
    uploader_cache.each do |model_name, columns|
      model_class = model_name.constantize

      columns.each do |column_name, cache_info|
        instance = model_class.find_by(id: cache_info["model_id"])
        next unless instance && instance.respond_to?(column_name)

        uploader = instance.send(column_name)
        uploader.retrieve_from_cache!(cache_info["cache_name"])
        uploader.store!
      end
    end
  end
end
