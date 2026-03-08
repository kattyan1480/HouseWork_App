class AddGroupToCategories < ActiveRecord::Migration[7.0]
  def change
    add_reference :categories, :group, null: false, foreign_key: true
  end
end