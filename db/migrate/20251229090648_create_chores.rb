class CreateChores < ActiveRecord::Migration[7.0]
  def change
    create_table :chores do |t|
      t.string :title
      t.text :detail
      t.integer :cake_reward
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
