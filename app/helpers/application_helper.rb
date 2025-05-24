module ApplicationHelper
  # タイトルの動的な変更
  def page_title(title = "")
    base_title = "アニめぐる"
    title.present? ? "#{title} | #{base_title}" : base_title
  end

  # デフォルトのメタタグを設定
  def default_meta_tags
    {
      site: "アニめぐる",
      title: "聖地巡礼情報共有プラットフォーム",
      reverse: true,
      charset: "utf-8",
      description: "あなたの足で紡ぐ、作品と現実の交差点。アニめぐるは、アニメファン向けの地巡礼情報共有プラットフォームです。聖地巡礼の思い出を聖地メモとして共有しよう。",
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

  # 全国47都道府県の名称を配列として返す
  def prefecture_options
    [
      "北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県",
      "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県",
      "新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県",
      "岐阜県", "静岡県", "愛知県", "三重県",
      "滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県",
      "鳥取県", "島根県", "岡山県", "広島県", "山口県",
      "徳島県", "香川県", "愛媛県", "高知県",
      "福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"
    ]
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
