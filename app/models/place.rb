class Place < ApplicationRecord
  has_many :seichi_memos, dependent: :destroy

  # geocodingについての設定
  geocoded_by :address
  after_validation :geocode

  # ransackで許可するカラム
  def self.ransackable_attributes(auth_object = nil)
    %w[name address]
  end

  # ransackで許可するテーブル
  def self.ransackable_associations(auth_object = nil)
    %w[seichi_memos]
  end
end
