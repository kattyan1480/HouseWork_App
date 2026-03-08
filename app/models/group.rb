class Group < ApplicationRecord
  has_many :users
  has_many :chores
  has_many :categories, dependent: :destroy
  has_many :chore_dates, through: :chores
  has_many :chore_histories, through: :chores

  validates :name, presence: true, length: { maximum: 50 }
  validates :passcode, presence: true, length: { minimum: 6 }
end