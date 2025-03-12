# Annict APIを使ってアニメの情報を検索するコントローラー
# ルーティング: GET /api/anime_search?title=タイトル名
require 'net/http'
require 'uri'
require 'json'

class Api::AnimeSearchController < ApplicationController
  # 検索用のエンドポイント
  def index
    # クエリパラメータ `title` を取得（ユーザーが入力したアニメのタイトル）
    title = params[:title]

    # タイトルが空の場合、エラーメッセージを返す（HTTPステータス 400: Bad Request）
    return render json: { error: "Title is required" }, status: 400 if title.blank?

    # 環境変数からAPIキーを取得（API認証のために必要）
    api_key = ENV["ANNICT_API_KEY"]

    # Annict APIのURLを作成（タイトルで検索）
    url = URI.parse("https://api.annict.com/v1/works?filter_title=#{URI.encode_www_form_component(title)}&per_page=1")

    # HTTPリクエストの準備
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true  # HTTPSを使用

    # GETリクエストを作成
    request = Net::HTTP::Get.new(url)
    # APIの認証情報をヘッダーに追加
    request["Authorization"] = "Bearer #{api_key}"

    # Annict APIにリクエストを送信し、レスポンスを取得
    response = http.request(request)

    Rails.logger.info "Annict API Response Code: #{response.code}"
    Rails.logger.info "Annict API Response: #{response.body}"

    # レスポンスのJSONをパース（Rubyのハッシュに変換）
    data = JSON.parse(response.body)

    # 作品データが存在する場合、必要な情報を返す
    if data["works"].present?
      anime = data["works"].first # 最初の作品データを取得
      render json: {
        title: anime["title"],  # 作品のタイトル
        official_site_url: anime["official_site_url"],  # 公式サイトのURL
      }
    else
      # 作品が見つからない場合、エラーメッセージを返す（HTTPステータス 404: Not Found）
      render json: { error: "Anime not found" }, status: 404
    end
  end
end
