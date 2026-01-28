class ChangeUniqueIndexOnChoreDates < ActiveRecord::Migration[7.0]
  def change
    remove_index :chore_dates, name: "index_chore_dates_on_chore_id_and_execute_date"

    add_index :chore_dates,
      "chore_id, DATE(execute_at)",
      unique: true,
      name: "index_chore_dates_on_chore_id_and_execute_date_pending",
      where: "status = 0" # pending
  end
end
