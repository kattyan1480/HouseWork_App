class RewardsController < ApplicationController
  before_action :set_reward, only: [:edit, :update, :expend]

  def index
    @rewards = current_user.rewards
  end

  def new
    @reward = current_user.rewards.build
  end

  def create
    @reward = current_user.rewards.build(reward_params)
    @reward.group = current_group

    if @reward.save
      redirect_to rewards_path, notice: "ご褒美を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # 編集画面でガントレット数を表示
    @reward.special_cost = (@reward.stamp_cost.to_i / 15)
  end

  def update
    if @reward.update(reward_params)
      redirect_to rewards_path, notice: "ご褒美を変更しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def expend
    user = current_user

    if user.stamp_amount < @reward.stamp_cost
      redirect_to rewards_path, alert: "チケットが足りません。"
      return
    end

    ActiveRecord::Base.transaction do
      user.update!(stamp_amount: user.stamp_amount - @reward.stamp_cost)
    end

    redirect_to rewards_path, notice: "ご褒美を獲得しました！🎉"
  rescue ActiveRecord::RecordInvalid
    redirect_to rewards_path, alert: "獲得に失敗しました。"
  end

  private

  def set_reward
    @reward = current_user.rewards.find(params[:id])
  end

  def reward_params
    params.require(:reward).permit(:title, :special_cost, :description)
  end
end