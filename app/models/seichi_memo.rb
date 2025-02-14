class SeichiMemo < ApplicationRecord
  belongs_to :user
  belongs_to :anime
  belongs_to :place

  mount_uploader :seichi_photo, SeichiPhotoUploader
  mount_uploader :scene_image, SceneImageUploader
end
