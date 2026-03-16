class Reward < ApplicationRecord
  belongs_to :group
  belongs_to :user

  validates :title, presence: true
  validates :stamp_cost,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than: 0,
      allow_blank: true
    }

  attr_accessor :special_cost

  before_validation :convert_special_cost

  SPECIAL_STAMP_SIZE = 15

  # 必要スペシャルスタンプ
  def special_cost
    (stamp_cost.to_f / SPECIAL_STAMP_SIZE).ceil
  end

  # 達成までスペシャルスタンプ
  def until_special(user)
    remain = stamp_cost - user.stamp_amount
    (remain / SPECIAL_STAMP_SIZE.to_f).ceil
  end

  # 達成済みか
  def achieved?(user)
    user.stamp_amount >= stamp_cost
  end

  def remain_special_after(user)
    current_special = user.stamp_amount / SPECIAL_STAMP_SIZE
    remain = current_special - special_cost
    remain < 0 ? 0 : remain
  end
  private

  def convert_special_cost
    return if special_cost.blank?

    self.stamp_cost = special_cost.to_i * 15
  end
end