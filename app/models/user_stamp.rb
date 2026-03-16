class UserStamp < ApplicationRecord
  belongs_to :user
  belongs_to :stamp
  belongs_to :chore_history
end