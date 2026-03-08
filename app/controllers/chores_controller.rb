class ChoresController < ApplicationController
  before_action :set_chore, only: [:show, :edit, :update, :destroy]

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
    @categories = current_user.group.categories
  end

  def create
    @chore = current_user.group.chores.build(chore_params)
    @categories = current_user.group.categories

    dates = params[:chore][:execute_dates].to_s.split(",").reject(&:blank?)
    time  = params[:chore][:execute_time]

    @chore.validate

    if dates.blank?
      @chore.errors.add(:execute_dates, "を入力してください")
    end

    if time.blank?
      @chore.errors.add(:execute_time, "を入力してください")
    end

    if @chore.errors.any?
      @pending_chore_dates = @chore.chore_dates.none
      return render :new, status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      @chore.save!

      dates.each do |date|
        datetime = Time.zone.parse("#{date} #{time}")
        @chore.chore_dates.create!(
          execute_at: datetime,
          status: :pending
        )
      end
    end

    redirect_to homes_index_path, notice: "家事を作成しました。"
  end

  def edit
    # set_chore
    @categories = current_user.group.categories
  end

  def update
    @categories = current_user.group.categories

    dates = params[:chore][:execute_dates].to_s.split(",").reject(&:blank?)
    time  = params[:chore][:execute_time]

    @chore.assign_attributes(chore_params)
    @chore.validate   # ← create と同じく明示的にvalidate

    if dates.blank?
      @chore.errors.add(:execute_dates, "を入力してください")
    end

    if time.blank?
      @chore.errors.add(:execute_time, "を入力してください")
    end

    if @chore.errors.any?
      @pending_chore_dates = @chore.chore_dates.pending.order(:execute_at)
      return render :edit, status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      @chore.save!

      # 未完了の実行日を削除
      @pending_chore_dates.destroy_all

      # 新しい実行日を作成
      dates.each do |date|
        datetime = Time.zone.parse("#{date} #{time}")

        @chore.chore_dates.create!(
          execute_at: datetime,
          status: :pending
        )
      end
    end

    redirect_to chores_path, notice: "家事を更新しました。"

  rescue ActiveRecord::RecordInvalid
    @pending_chore_dates = @chore.chore_dates.pending.order(:execute_at)
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @pending_chore_dates.destroy_all
    redirect_to chores_path, notice: "家事を削除しました。"
  end

  def history
    @chore_dates = current_user.group.chore_dates
                          .done
                          .includes(chore: {}, chore_histories: :user)
                          .order('chore_histories.done_at DESC')
  end

  private

  def set_chore
    @chore = current_user.group.chores.find(params[:id])
    @pending_chore_dates = @chore.chore_dates.pending.order(:execute_at)
  end

  def chore_params
    params.require(:chore).permit(
      :title,
      :stamp_reward,
      :detail,
      :category_id
    )
  end
end
