class ChoreDatesController < ApplicationController
  def destroy
    chore_date = current_user.group.chore_dates.find(params[:id])
    chore_date.destroy
    redirect_to root_path, notice: "今日の家事を削除しました"
  end

  def complete
    chore_date = current_user.group.chore_dates.find(params[:id])
    chore = chore_date.chore

    user_ids = params[:completed_user_ids]

    # チェックなし防止
    if user_ids.blank?
      redirect_back fallback_location: root_path, alert: "完了者を選択してください"
      return
    end

    ActiveRecord::Base.transaction do
      # ① ステータスを完了に
      chore_date.update!(status: :done)

      # ② ケーキを山分け
      per_user_cake = (chore.cake_reward.to_f / user_ids.size).ceil

      user_ids.each do |user_id|
        ChoreHistory.create!(
          chore: chore,
          user_id: user_id,
          chore_date: chore_date,
          cake_reward_count: per_user_cake,
          done_at: Time.current
        )
      end
    end

    redirect_to homes_index_path, notice: "家事を完了しました"
  end

  def reschedule
    @chore_date = ChoreDate.find(params[:id])

    if @chore_date.update(execute_at: params[:execute_at])
      redirect_to root_path, notice: "実施日を変更しました"
    else
      redirect_to root_path, alert: @chore_date.errors.full_messages.join("、")
    end
  end
end