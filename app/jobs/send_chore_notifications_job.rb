class SendChoreNotificationsJob < ApplicationJob
  queue_as :default

  def perform
    now = Time.current
    Rails.logger.info "===== CHORE NOTIFICATION JOB START now=#{now} ====="

    targets = ChoreDate
      .includes(chore: { group: :users })
      .where(status: :pending)
      .where(notification_sent_at: nil)
      .where(execute_at: (now - 5.minutes)..now)

    Rails.logger.info "TARGET COUNT = #{targets.count}"

    targets.find_each do |chore_date|
      Rails.logger.info "TARGET CHORE_DATE ID=#{chore_date.id} TITLE=#{chore_date.chore.title} EXECUTE_AT=#{chore_date.execute_at}"

      chore_date.chore.group.users.each do |user|
        Rails.logger.info "USER ID=#{user.id}"

        subs = user.web_push_subscriptions
        Rails.logger.info "SUBSCRIPTION COUNT=#{subs.count}"

        subs.find_each do |subscription|
          Rails.logger.info "SEND PUSH subscription_id=#{subscription.id}"

          WebPushNotifier.send_notification(
            subscription: subscription,
            title: "家事の時間です",
            body: "「#{chore_date.chore.title}」の時間になりました",
            url: "/"
          )
        end
      end

      chore_date.update!(notification_sent_at: now)
      Rails.logger.info "UPDATED notification_sent_at"
    end

    Rails.logger.info "===== CHORE NOTIFICATION JOB END ====="
  end
end