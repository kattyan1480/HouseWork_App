class Reward < ApplicationRecord
  belongs_to :group
  belongs_to :user

  validates :title, presence: true
  validates :cake_cost,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than: 0,
      allow_blank: true
    }
end