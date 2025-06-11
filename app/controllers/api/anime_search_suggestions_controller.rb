class Api::AnimeSearchSuggestionsController < ApplicationController
  # HTTPリクエストとJSON処理のための標準ライブラリを読み込み
  require "net/http"
  require "json"

  # オートコンプリート候補を返すアクション
  def index
    # クエリパラメータ（title）を取得し、前後の空白を削除
    title = params[:title].to_s.strip

    # 環境変数からAnnictのAPIキーを取得
    api_key = ENV["ANNICT_API_KEY"]

    # Annict APIのエンドポイントURIを作成（検索ワードと最大件数を指定）
    uri = URI("https://api.annict.com/v1/works")
    uri.query = URI.encode_www_form({ filter_title: title, per_page: 10 })

    # HTTPSでリクエストを送るための準備
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    # 認証ヘッダー付きのGETリクエストを作成
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{api_key}"

    # Annict APIにリクエストを送信してレスポンスを取得
    response = http.request(request)

    # レスポンスボディをJSON形式からRubyのハッシュに変換
    data = JSON.parse(response.body)

    # 検索結果がある場合は、候補データを整形して返す
    if data["works"].present?
      suggestions = data["works"].map do |anime|
        {
          title: anime["title"],                    # 作品タイトル
          official_site_url: anime["official_site_url"] # 公式サイトURL
        }
      end

      # 整形した候補リストをJSONとして返す
      render json: suggestions
    else
      # 結果がない場合は空の配列を返す（ステータスは200）
      render json: []
    end
  end
end
