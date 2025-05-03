class GenreTag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :seichi_memos, through: :taggings

  validates :name, presence: true, uniqueness: true
end
