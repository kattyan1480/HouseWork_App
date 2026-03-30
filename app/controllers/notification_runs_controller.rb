class NotificationRunsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_scheduler_token

  def create
    SendChoreNotificationsJob.perform_now
    head :ok
  end

  private

  def verify_scheduler_token
    token = request.headers["X-Scheduler-Token"].to_s
    expected = ENV["SCHEDULER_TOKEN"].to_s

    if expected.blank? || token.blank?
      head :unauthorized
      return
    end

    unless ActiveSupport::SecurityUtils.secure_compare(token, expected)
      head :unauthorized
    end
  end
end