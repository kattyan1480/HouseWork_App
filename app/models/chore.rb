class Chore < ApplicationRecord
  belongs_to :group
  has_many :chore_dates, dependent: :destroy

  validates :name, presence: true
  validates :cake_reward,
            presence: true,
            numericality: { only_integer: true, greater_than: 0 }
end
