class AchievementsController < ApplicationController
  def index
    @users = current_group.users.order(:id)

    # 表示対象ユーザー（未指定なら自分）
    @user = if params[:user_id].present?
              @users.find(params[:user_id])
            else
              current_user
            end
  end
end