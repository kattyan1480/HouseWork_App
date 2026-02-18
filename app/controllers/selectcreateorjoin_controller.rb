class SelectcreateorjoinController < ApplicationController
  before_action :authenticate_user!

  def select
    # 作成 or 参加 の選択画面
  end

  def decide
    session["selectcreateorjoin"] ||= {}
    session["selectcreateorjoin"]["mode"] = params[:mode]

    redirect_to selectcreateorjoin_form_path
  end

  def form
    @mode = session.dig("selectcreateorjoin", "mode")
    redirect_to selectcreateorjoin_select_path unless @mode
  end

  def save_form
    mode = session.dig("selectcreateorjoin", "mode")
    redirect_to selectcreateorjoin_select_path and return unless mode

    if mode == "create"
      group = Group.create!(
        name: params[:group_name],
        passcode: params[:passcode]
      )
    elsif mode == "join"
      group = Group.find_by!(
        name: params[:group_name],
        passcode: params[:passcode]
      )
    end

    # ユーザーの更新
    current_user.update!(
      group: group,
      name: params[:name],          # ニックネーム
      avatar_image: params[:avatar_image]  # プロフィール画像
    )

    Reward.create!(
      user: current_user,
      group: group,
      title: "ごほうびを設定してください",
      cake_cost: 0
    )

    session.delete("selectcreateorjoin")
    redirect_to root_path
  end
end
