class CreateChoreHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :chore_histories do |t|
      t.references :chore, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :chore_date, null: false, foreign_key: true

      t.integer :cake_count, null: false, default: 0
      t.datetime :done_at, null: false
    end
  end
end

