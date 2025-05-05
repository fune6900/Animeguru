class GenreTag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :seichi_memos, through: :taggings

  validates :name, presence: true, uniqueness: true

  #ransackで許可するカラムを指定
  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end

  #ransackで許可するテーブルを指定
  def self.ransackable_associations(auth_object = nil)
    %w[seichi_memos]
  end
end
