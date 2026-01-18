class RemoveIconFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :icon, :string
  end
end
