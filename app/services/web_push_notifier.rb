class WebPushNotifier
  def self.send_notification(subscription:, title:, body:, url:)
    payload = {
      title: title,
      body: body,
      url: url
    }.to_json

    WebPush.payload_send(
      message: payload,
      endpoint: subscription.endpoint,
      p256dh: subscription.p256dh,
      auth: subscription.auth,
      vapid: {
        subject: ENV["VAPID_SUBJECT"],
        public_key: ENV["VAPID_PUBLIC_KEY"],
        private_key: ENV["VAPID_PRIVATE_KEY"]
      }
    )
  rescue WebPush::InvalidSubscription, WebPush::ExpiredSubscription
    subscription.destroy
  rescue StandardError => e
    Rails.logger.error("WEB_PUSH_ERROR #{e.class}: #{e.message}")
    raise
  end
end