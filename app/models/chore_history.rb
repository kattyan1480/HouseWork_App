class ChoreHistory < ApplicationRecord
  belongs_to :user
  belongs_to :chore
  belongs_to :chore_date
  has_one :user_stamp
end
