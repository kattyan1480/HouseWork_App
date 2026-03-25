class PushTestsController < ApplicationController
  before_action :authenticate_user!

  def create
    subscription = current_user.web_push_subscriptions.last

    if subscription.blank?
      redirect_to root_path, alert: "通知先端末が登録されていません。"
      return
    end

    WebPushNotifier.send_notification(
      subscription: subscription,
      title: "テスト通知",
      body: "通知タップでホーム画面を開きます",
      url: "/"
    )

    redirect_to root_path, notice: "テスト通知を送信しました。"
  end
end