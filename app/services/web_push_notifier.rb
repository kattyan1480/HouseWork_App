class WebPushNotifier
  def self.send_notification(subscription:, title:, body:, url:, chore_date_id: nil)
    payload = {
      title: title,
      body: body,
      url: url
    }.to_json

    Webpush.payload_send(
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
  rescue Webpush::InvalidSubscription, Webpush::ExpiredSubscription
    subscription.destroy
  end
end