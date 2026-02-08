class CreateRewards < ActiveRecord::Migration[7.0]
  def change
    create_table :rewards do |t|
      t.references :group, null: false, foreign_key: true
      t.references :user,  null: false, foreign_key: true, index: { unique: true }

      t.string  :title,     null: false
      t.integer :cake_cost, null: false

      t.timestamps
    end
  end
end

