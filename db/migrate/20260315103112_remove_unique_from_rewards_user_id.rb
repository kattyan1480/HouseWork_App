class RemoveUniqueFromRewardsUserId < ActiveRecord::Migration[7.0]
  def change
    remove_index :rewards, :user_id
    add_index :rewards, :user_id
  end
end
