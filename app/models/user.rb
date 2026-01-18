class User < ApplicationRecord
  belongs_to :group, optional: true
  has_one_attached :avatar_image
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable # メール確認用
end
