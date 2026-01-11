class UpdateChoreDatesColumns < ActiveRecord::Migration[7.0]
  def change
    remove_column :chore_dates, :occurrence_date, :date

    rename_column :chore_dates, :executed_at, :execute_at
  end
end
