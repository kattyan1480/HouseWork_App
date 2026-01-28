class Group < ApplicationRecord
  has_many :users
  has_many :chores
  has_many :chore_dates, through: :chores
  has_many :chore_histories, through: :chores
end
