module ApplicationHelper
  # デフォルトのメタタグを設定
  def default_meta_tags
    {
      site: "アニめぐる",
      title: "聖地巡礼情報共有プラットフォーム",
      reverse: true,
      charset: "utf-8",
      description: "あなたの足で紡ぐ、作品と現実の交差点。アニめぐるは、アニメファンや聖地巡礼を考えている人のための聖地巡礼情報共有プラットフォームです。あなたの聖地巡礼の思い出を聖地メモとして共有しよう。",
      keywords: "聖地巡礼, アニメ聖地, アニメの舞台, 聖地, 巡礼記録, 聖地マップ, アニメ巡り, 聖地投稿, アニメロケ地, アニメスポット, 作品の舞台, モデル地, アニメファン, アニメ×現実, 推し活, アニめぐる",
      canonical: request.original_url,
      separator: "|",
      og: {
        site_name: :site,
        title: content_for(:og_title) || :title,
        description: content_for(:og_description) || :description,
        type: "website",
        url: request.original_url,
        image: image_url("ogp.png"),
        local: "ja-JP"
      },
      twitter: {
        card: "summary_large_image",
        site: "@fune_6900",
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
