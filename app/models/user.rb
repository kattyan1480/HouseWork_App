class User < ApplicationRecord
  belongs_to :group, optional: true
  has_one_attached :avatar_image
  has_one :reward, dependent: :destroy
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable # メール確認用

  def avatar_image_or_default
    if avatar_image.attached?
      avatar_image
    else
      "default_avatar.png"
    end
  end
end
