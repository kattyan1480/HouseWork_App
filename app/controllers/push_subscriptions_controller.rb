class PushSubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    subscription_params = params.require(:subscription).permit(
      :endpoint,
      keys: [:p256dh, :auth]
    )

    record = current_user.web_push_subscriptions.find_or_initialize_by(
      endpoint: subscription_params[:endpoint]
    )

    record.p256dh = subscription_params.dig(:keys, :p256dh)
    record.auth   = subscription_params.dig(:keys, :auth)
    record.save!

    head :ok
  end

  def destroy
    current_user.web_push_subscriptions
                .where(endpoint: params[:endpoint])
                .destroy_all

    head :ok
  end
end
