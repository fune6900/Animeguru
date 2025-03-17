# ルーティング: GET /api/anime_search?title=作品タイトル名

class Api::AnimeSearchController < ApplicationController
  require "net/http"
  require "json"

  def index
    # ユーザーの作品タイトル名を取得
    title = params[:title]

    # 環境変数からAPIキーを取得
    api_key = ENV["ANNICT_API_KEY"]

    # Annict APIのURLを設定（タイトルで検索）
    url = URI.parse("https://api.annict.com/v1/works?filter_title=#{URI.encode_www_form_component(title)}&per_page=1")

    # HTTPリクエストの準備
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true  # HTTPSを使用

    # GETリクエストを作成
    request = Net::HTTP::Get.new(url)
    request["Authorization"] = "Bearer #{api_key}" # APIの認証情報をヘッダーに追加

    # Annict APIにリクエストを送信
    response = http.request(request)

    # レスポンスのJSONをRubyのハッシュに変換
    data = JSON.parse(response.body)

    # 作品データが存在する場合、必要な情報を返す
    if data["works"].present?
      anime = data["works"].first # 最初の作品データを取得
      render json: {
        title: anime["title"],  # 作品のタイトル
        official_site_url: anime["official_site_url"]  # 公式サイトのURL
      }
    else
      render json: { error: "Anime not found" }, status: 404
    end
  end
end
