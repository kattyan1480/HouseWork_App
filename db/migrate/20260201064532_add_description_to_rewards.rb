class AddDescriptionToRewards < ActiveRecord::Migration[7.0]
  def change
    add_column :rewards, :description, :text
  end
end
