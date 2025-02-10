class Place < ApplicationRecord
  has_many :seichi_memos, dependent: :destroy
end
