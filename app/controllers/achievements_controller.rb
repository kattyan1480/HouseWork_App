class AchievementsController < ApplicationController
  def index
    @users = current_group.users.order(:id)

    # 表示対象ユーザー（未指定なら自分）
    @user = if params[:user_id].present?
              @users.find(params[:user_id])
            else
              current_user
            end

    # カテゴリ別スタンプ数
    @stamp_counts =
      ChoreHistory
        .joins(chore: :category)
        .where(user_id: @user.id)
        .group("categories.id")
        .sum(:stamp_reward_count)

    # スタンプを持っているカテゴリ
    @categories = Category.where(id: @stamp_counts.keys)

  end
end