class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> {order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length:{maximum: Settings.max_content}

  private
    def picture_size
      if picture.size > 5.megabytes
        errors.add :picture, t("micropost.upload_image")
      end
    end
end
