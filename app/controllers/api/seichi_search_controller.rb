# ルーティング: GET /api/seichi_search?query=聖地名

class Api::SeichiSearchController < ApplicationController
  require 'net/http'
  require 'json'

  def index
    # ユーザーの聖地名を取得
    query = params[:query] 
    
    # Google Places APIのURLを設定
    uri = URI("https://places.googleapis.com/v1/places:searchText")

    # POSTリクエストを作成
    request = Net::HTTP::Post.new(uri.path) 
    request["Content-Type"] = "application/json"
    request["X-Goog-Api-Key"] = ENV['GOOGLE_PLACES_API_KEY']
    request["X-Goog-FieldMask"] = "places.formattedAddress,places.addressComponents"

    # 送信データをJSONに変換
    request.body = JSON.dump({ "textQuery" => query, "languageCode" => "ja" })

    # APIにリクエストを送信
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(request) } 

    # レスポンスのJSONをRubyのハッシュに変換
    data = JSON.parse(response.body)

    place = data["places"]&.first # 最も関連性の高い1件目の情報を取得
    address = place ? place["formattedAddress"] : "" # 住所を取得
    postal_code = place ? place["addressComponents"]&.find { |c| c["types"].include?("postal_code") }&.dig("shortText") : "" # 郵便番号を取得

    # 住所と郵便番号をJSONで返す
    render json: { address: address, postal_code: postal_code }
  end
end
