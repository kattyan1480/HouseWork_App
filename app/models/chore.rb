class Chore < ApplicationRecord
  belongs_to :group
  belongs_to :category
  has_many :chore_dates, dependent: :destroy
  has_many :chore_histories

  validates :title, presence: true

  validates :stamp_reward,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than: 0,
      allow_blank: true
    }
end
