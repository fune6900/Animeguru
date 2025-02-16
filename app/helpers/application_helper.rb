module ApplicationHelper
  # フラッシュメッセージの背景色を変更
  def flash_background_color(type)
    case type.to_sym
    when :notice then "bg-green-500"  # 成功（緑）
    when :alert  then "bg-red-500"    # 失敗（赤）
    when :warning then "bg-yellow-500" # 警告（黄）
    when :info   then "bg-blue-500"   # 情報（青）
    else "bg-gray-500"
    end
  end
end
