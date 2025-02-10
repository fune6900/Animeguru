class SeichiMemo < ApplicationRecord
  belongs_to :user
  belongs_to :anime
  belongs_to :place
end
