class ChoreDatesController < ApplicationController

  def show
    @chore_date = ChoreDate
                    .joins(chore: :group)
                    .where(groups: { id: current_user.group.id })
                    .find(params[:id])
  end

  def destroy
    chore_date = current_group.chore_dates.find(params[:id])
    chore_date.destroy
    redirect_to root_path, notice: "家事を削除しました。"
  end

  def complete
    chore_date = current_group.chore_dates.find(params[:id])
    chore = chore_date.chore

    user_ids = params[:completed_user_ids]

    # チェックなし防止
    if user_ids.blank?
      redirect_back fallback_location: root_path, alert: "完了者を選択してください。"
      return
    end

    ActiveRecord::Base.transaction do
      # ① ステータスを完了に
      chore_date.update!(status: :done)

      # ② ケーキを山分け
      per_user_stamp = (chore.stamp_reward.to_f / user_ids.size).ceil

      user_ids.each do |user_id|
        user = User.find(user_id)

        # ③ 家事履歴を作成
        ChoreHistory.create!(
          chore: chore,
          user: user,
          chore_date: chore_date,
          stamp_reward_count: per_user_stamp,
          done_at: Time.current
        )

        # ④ ケーキを加算
        user.update!(
          stamp_amount: user.stamp_amount + per_user_stamp
        )
      end
    end

    redirect_to homes_index_path, notice: "家事を完了しました。"
  end

  def reschedule
    @chore_date = current_group.chore_dates.find(params[:id])

    new_date = Date.parse(params[:execute_at])

    new_execute_at = @chore_date.execute_at.change(
      year: new_date.year,
      month: new_date.month,
      day: new_date.day
    )

    if @chore_date.update(execute_at: new_execute_at)
      redirect_to root_path, notice: "実施日を変更しました。"
    else
      redirect_to root_path, alert: @chore_date.errors.full_messages.join("、")
    end
  end
end