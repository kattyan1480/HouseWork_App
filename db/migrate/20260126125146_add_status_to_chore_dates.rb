class AddStatusToChoreDates < ActiveRecord::Migration[7.0]
  def change
    add_column :chore_dates, :status, :integer, null: false, default: 0
  end
end
