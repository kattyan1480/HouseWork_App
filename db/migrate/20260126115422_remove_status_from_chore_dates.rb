class RemoveStatusFromChoreDates < ActiveRecord::Migration[7.0]
  def change
    remove_column :chore_dates, :status, :integer
  end
end
