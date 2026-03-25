class User < ApplicationRecord
  belongs_to :group, optional: true
  has_many :chore_histories, dependent: :destroy
  has_one_attached :avatar_image
  has_many :rewards, dependent: :destroy
  has_many :user_stamps, dependent: :destroy
  has_many :web_push_subscriptions, dependent: :destroy
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  validates :email, presence: true
  validates :password, presence: true, on: :create
  validates :name,
            presence: true,
            length: { maximum: 20 },
            on: :update

  def avatar_image_or_default
    if avatar_image.attached?
      avatar_image
    else
      "default_avatar.png"
    end
  end

  # スペシャルスタンプ数
  def special_stamp_count
    stamp_amount / 15
  end

  # 現在のシートのスタンプ数
  def current_stamp_count
    stamp_amount % 15
  end

  # 現在シートに表示するスタンプ
  def display_stamps
    count = current_stamp_count

    return [] if count == 0

    user_stamps
      .includes(:stamp)
      .order(created_at: :desc)
      .limit(count)
      .map { |us| us.stamp.image }
      .reverse
  end
end
