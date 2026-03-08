class RenameCakeColumnsToStamp < ActiveRecord::Migration[7.0]
  def change
    rename_column :chore_histories, :cake_reward_count, :stamp_reward_count
    rename_column :chores, :cake_reward, :stamp_reward
    rename_column :rewards, :cake_cost, :stamp_cost
    rename_column :users, :cake_amount, :stamp_amount
  end
end