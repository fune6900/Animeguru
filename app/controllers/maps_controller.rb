class MapsController < ApplicationController
  def index
    @seichi_memos = SeichiMemo.includes(:anime, :place, :user, :genre_tags).where.not(places: { address: "", latitude: nil, longitude: nil })
  end
end
