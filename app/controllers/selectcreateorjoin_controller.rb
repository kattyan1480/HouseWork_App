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
    return redirect_to selectcreateorjoin_select_path unless @mode

    @user  = current_user
    @group = Group.new
  end

def save_form
    @mode = session.dig("selectcreateorjoin", "mode")
    return redirect_to selectcreateorjoin_select_path unless @mode

    @user  = current_user
    @group = build_group_by_mode

    # ユーザー属性セット
    @user.assign_attributes(
      name: params[:name].presence,
      avatar_image: params[:avatar_image]
    )

    # 統一バリデーション
    @user.validate
    @group.validate if @mode == "create"

    if @user.errors.any? || @group.errors.any?
      return render :form, status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      @group.save! if @mode == "create"

      @user.group = @group
      @user.save!

      Reward.create!(
        user: @user,
        group: @group,
        title: "ごほうびを設定して下さい",
        cake_cost: 1
      )
    end

    session.delete("selectcreateorjoin")
    redirect_to root_path
  end

  private

def build_group_by_mode
  case @mode
  when "create"
    Group.new(
      name: params[:group_name],
      passcode: params[:passcode]
    )

  when "join"
    # まず入力値をセット
    g = Group.new(
      name: params[:group_name],
      passcode: params[:passcode]
    )

    # 🔹 空白チェック（presence）
    g.validate
    return g if g.errors.any?

    # 🔹 DB照合
    group = Group.find_by(
      name: params[:group_name],
      passcode: params[:passcode]
    )

    return group if group

    # 🔥 一致しない場合は base に追加（フォーム上部表示用）
    g.errors.add(:base, "グループ名または合言葉が正しくありません")

    g
  end
end
end