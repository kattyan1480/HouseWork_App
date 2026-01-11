class ChoresController < ApplicationController
  before_action :set_chore, only: [:edit, :update, :destroy]

  def index
    @chores = current_user.group.chores
  end

  def new
    @chore = Chore.new
  end

  def create
    @chore = current_user.group.chores.build(chore_params)

    dates = params[:chore][:execute_dates].split(",")
    time  = params[:chore][:execute_time]

    ActiveRecord::Base.transaction do
      @chore.save!

      dates.each do |date|
        datetime = Time.zone.parse("#{date} #{time}")

        @chore.chore_dates.create!(
          execute_at: datetime
        )
      end
    end

    redirect_to root_path, notice: "家事を登録しました"
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def edit
    # set_chore が @chore を用意してくれる
  end

  def update
    @chore = current_user.group.chores.find(params[:id])

    dates = params[:chore][:execute_dates].split(",")
    time  = params[:chore][:execute_time]

    ActiveRecord::Base.transaction do
      @chore.update!(chore_params)

      # ① 既存の実行日を全削除
      @chore.chore_dates.destroy_all

      # ② 新しい実行日を作り直す
      dates.each do |date|
        datetime = Time.zone.parse("#{date} #{time}")

        @chore.chore_dates.create!(
          execute_at: datetime
        )
      end
    end

    redirect_to @chore, notice: "更新しました"
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  def destroy
    @chore.destroy
    redirect_to chores_path, notice: "家事を削除しました"
  end

  private

  def set_chore
    @chore = current_user.group.chores.find(params[:id])
  end

  def chore_params
    params.require(:chore).permit(
      :title,
      :cake_reward,
      :detail
    )
  end
end

