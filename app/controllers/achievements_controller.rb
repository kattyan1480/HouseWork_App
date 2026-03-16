class AchievementsController < ApplicationController
  def index
    @users = current_group.users.order(:id)

    @user =
      if params[:user_id]
        @users.find(params[:user_id])
      else
        @users.first
      end

    @stamps = @user.display_stamps

    @special_stamp_count = @user.special_stamp_count
    @current_stamp_count = @user.current_stamp_count

    @rewards = @user.rewards
  end
end