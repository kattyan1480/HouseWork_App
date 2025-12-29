class CreateChoreDates < ActiveRecord::Migration[7.0]
  def change
    create_table :chore_dates do |t|
      t.references :chore, null: false, foreign_key: true
      t.date :occurrence_date, null: false
      t.datetime :executed_at
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
