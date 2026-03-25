class AddNotificationSentAtToChoreDates < ActiveRecord::Migration[7.0]
  def change
    add_column :chore_dates, :notification_sent_at, :datetime
  end
end
