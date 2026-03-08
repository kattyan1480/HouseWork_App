class AddCategoryToChores < ActiveRecord::Migration[7.0]
  def change
    add_reference :chores, :category, null: false, foreign_key: true
  end
end