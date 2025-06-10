# ルーティング: GET /api/seichi_search_suggestions?query=聖地名
class Api::SeichiSearchController < ApplicationController
  require "net/http"
  require "json"

  def suggestions
    query = params[:query]
    return render json: [] if query.blank?

    uri = URI("https://places.googleapis.com/v1/places:searchText")

    request = Net::HTTP::Post.new(uri.path)
    request["Content-Type"] = "application/json"
    request["X-Goog-Api-Key"] = ENV["GOOGLE_PLACES_API_KEY"]
    request["X-Goog-FieldMask"] = "places.displayName,places.formattedAddress,places.addressComponents"

    request.body = JSON.dump({ "textQuery" => query, "languageCode" => "ja" })

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(request) }

    data = JSON.parse(response.body)

    suggestions = data["places"]&.map do |place|
      {
        name: place.dig("displayName", "text"),
        address: place["formattedAddress"] || "",
        postal_code: place["addressComponents"]&.find { |c| c["types"].include?("postal_code") }&.dig("shortText") || ""
      }
    end || []

    render json: suggestions
  end
end
