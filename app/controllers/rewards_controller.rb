class RewardsController < ApplicationController
  def index
  end

  def new
    @reward = Reward.new
  end

  def create
    @reward = current_user.reward || current_user.build_reward
    @reward.assign_attributes(reward_params)
    @reward.group = current_group

    if @reward.save
      redirect_to achievements_path, notice: "ご褒美を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @reward = current_user.reward
  end

  def update
    @reward = current_user.reward
    if @reward.update(reward_params)
      redirect_to achievements_path, notice: "ご褒美を変更しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def expend
    reward = current_user.reward
    user   = current_user

    if user.cake_amount < reward.cake_cost
      redirect_to reward_path, alert: "ケーキが足りません。"
      return
    end

    ActiveRecord::Base.transaction do
      user.update!(cake_amount: user.cake_amount - reward.cake_cost)
      # reward.update!(acquired: true) ← 次の一手
    end

    redirect_to reward_path, notice: "ご褒美を獲得しました！🎉"
  rescue ActiveRecord::RecordInvalid
    redirect_to reward_path, alert: "獲得に失敗しました。"
  end

  private

  def reward_params
    params.require(:reward).permit(:title, :cake_cost, :description)
  end
end