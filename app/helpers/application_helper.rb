module ApplicationHelper

  # デフォルトのメタタグを設定
  def default_meta_tags
    {
      site: "アニめぐる",
      title: "アニめぐる",
      reverse: true,
      charset: "utf-8",
      description: "アニめぐるは、聖地巡礼のための情報を共有するプラットフォームです。",
      canonical: request.original_url,
      separator: "|",
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: request.original_url,
        image: image_url("ogp.png"),
        local: "ja-JP"
      },
      twitter: {
        card: "summary_large_image",
        site: "@https://x.com/fune_6900",
        image: image_url("ogp.png")
      }
    }
  end

  # フラッシュメッセージの背景色を変更
  def flash_background_color(type)
    case type.to_sym
    when :notice, :comment_notice then "bg-green-500"  # 成功（緑）
    when :alert, :comment_alert  then "bg-red-500"    # 失敗（赤）
    when :warning then "bg-yellow-500" # 警告（黄）
    when :info   then "bg-blue-500"   # 情報（青）
    else "bg-gray-500"
    end
  end

  # フラッシュメッセージのアイコンを変更
  def flash_icon_class(type)
    case type.to_sym
    when :notice, :comment_notice
      "fas fa-check-circle"  # 成功
    when :alert, :comment_alert
      "fas fa-exclamation-triangle"  # 警告
    when :error
      "fas fa-times-circle"  # エラー
    else
      "fas fa-info-circle"  # その他
    end
  end
end
