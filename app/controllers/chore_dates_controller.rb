class ChoreDatesController < ApplicationController
  def destroy
    chore_date = current_user.group.chore_dates.find(params[:id])
    chore_date.destroy
   redirect_to root_path, notice: "今日の家事を削除しました"
  end
end