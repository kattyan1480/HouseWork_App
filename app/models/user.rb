class User < ApplicationRecord
  belongs_to :group
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable # メール確認用
end
