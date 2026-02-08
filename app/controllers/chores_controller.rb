class ChoresController < ApplicationController
  before_action :set_chore, only: [:edit, :update, :destroy]

  def index
    @chores =
      current_user.group.chores
        .joins(:chore_dates)
        .where(chore_dates: { status: :pending })
        .distinct
  end

  def new
    @chore = Chore.new
    @pending_chore_dates = @chore.chore_dates.none 
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

    redirect_to homes_index_path, notice: "家事を登録しました"
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def edit
    # set_chore
  end

  def update
    # set_chore
    dates = params[:chore][:execute_dates].split(",")
    time  = params[:chore][:execute_time]

    ActiveRecord::Base.transaction do
      @chore.update!(chore_params)

      # ① 未完了の実行日のみ削除
      @pending_chore_dates.destroy_all

      # ② 新しい実行日を作り直す（pending）
      dates.each do |date|
        datetime = Time.zone.parse("#{date} #{time}")

        @chore.chore_dates.create!(
          execute_at: datetime,
          status: :pending
        )
      end
    end

    redirect_to chores_path, notice: "更新しました"
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  def destroy
    # set_chore
    @pending_chore_dates.destroy_all
    redirect_to chores_path, notice: "家事を削除しました"
  end

  def history
    @chore_dates = current_user.group.chore_dates
                          .done
                          .includes(chore: {}, chore_histories: :user)
                          .order('chore_histories.done_at DESC')
                          .page(params[:page])
                          .per(10)
  end

  private

  def set_chore
    @chore = current_user.group.chores.find(params[:id])
    @pending_chore_dates = @chore.chore_dates.pending.order(:execute_at)
  end

  def chore_params
    params.require(:chore).permit(
      :title,
      :cake_reward,
      :detail
    )
  end
end

