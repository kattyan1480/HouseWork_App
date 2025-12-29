class ChoresController < ApplicationController
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

  private

  def chore_params
    params.require(:chore).permit(
      :name,
      :detail,
      :cake_reward
    )
  end
end

