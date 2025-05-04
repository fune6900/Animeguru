class Place < ApplicationRecord
  has_many :seichi_memos, dependent: :destroy

  # geocodingについての設定
  geocoded_by :address
  after_validation :geocode

  #ransackで許可するカラム
  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end
end
