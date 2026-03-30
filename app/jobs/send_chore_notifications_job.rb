class SendChoreNotificationsJob < ApplicationJob
  queue_as :default

  def perform
    now = Time.current

    ChoreDate
      .includes(chore: { group: :users })
      .where(status: :pending)
      .where(notification_sent_at: nil)
      .where(execute_at: (now - 5.minutes)..now)
      .find_each do |chore_date|

      chore_date.chore.group.users.each do |user|
        user.web_push_subscriptions.find_each do |subscription|
          WebPushNotifier.send_notification(
            subscription: subscription,
            title: "家事の時間です",
            body: "「#{chore_date.chore.title}」の時間になりました",
            url: "/"
          )
        end
      end

      chore_date.update!(notification_sent_at: now)
    end
  end
end