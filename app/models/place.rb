class Place < ApplicationRecord
  has_many :seichi_memos, dependent: :destroy

  # geocodingについての設定
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
end
