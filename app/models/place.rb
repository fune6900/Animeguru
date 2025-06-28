class Place < ApplicationRecord
  has_many :seichi_memos, dependent: :destroy

  # geocodingについての設定
  geocoded_by :address
  after_validation :geocode

  # バリデーション
  validates :name, presence: true, length: { maximum: 100 }, uniqueness: true
  validates :address, length: { maximum: 200 }, allow_blank: true
  validates :postal_code, format: { with: /\A\d{3}-\d{4}\z/, message: "はXXX-XXXXの形式で入力してください" }, allow_blank: true

  # ransackで許可するカラム
  def self.ransackable_attributes(auth_object = nil)
    %w[name address]
  end

  # ransackで許可するテーブル
  def self.ransackable_associations(auth_object = nil)
    %w[seichi_memos]
  end
end
