class AddUniqueIndexToChoreDates < ActiveRecord::Migration[7.0]
  def change
    add_index :chore_dates,
              "chore_id, DATE(execute_at)",
              unique: true,
              name: "index_chore_dates_on_chore_id_and_execute_date"
  end
end
