class HomesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_group!

  def index
    today_range =
      Time.zone.now.beginning_of_day..Time.zone.now.end_of_day

    @today_chore_dates =
      current_user.group
                  .chore_dates
                  .where(execute_at: today_range, status: :pending)
                  .includes(:chore)

    yesterday_range =
      (Time.zone.now - 1.day).beginning_of_day..(Time.zone.now - 1.day).end_of_day

    @yesterday_chore_dates =
      current_user.group
                  .chore_dates
                  .where(execute_at: yesterday_range, status: :pending)
                  .includes(:chore)
  end

  def previous
    before_yesterday_range =
      ..(Time.zone.now - 2.day).end_of_day

    @before_yesterday_chore_dates =
      current_user.group
                  .chore_dates
                  .where(execute_at: before_yesterday_range, status: :pending)
                  .includes(:chore)
                  .order(execute_at: :desc)
                  .page(params[:page])
                  .per(10)
  end

  private

  def ensure_group!
    return if current_user.group.present?

    redirect_to selectcreateorjoin_select_path
  end
end
