class ChoreHistory < ApplicationRecord
  belongs_to :chore
  belongs_to :user
  belongs_to :chore_date
end
