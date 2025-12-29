class ChoreDate < ApplicationRecord
  belongs_to :chore
  validates :execute_at, presence: true
  enum status: { pending: 0, done: 1 }
end
