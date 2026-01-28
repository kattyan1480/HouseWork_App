class ChangeColumnName < ActiveRecord::Migration[7.0]
  def change
    rename_column :chore_histories, :cake_count, :cake_reward_count
  end
end
