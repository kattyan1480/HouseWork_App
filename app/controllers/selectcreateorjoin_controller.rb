class SelectcreateorjoinController < ApplicationController
  def select
    # 表示用
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
    session["selectcreateorjoin"] ||= {}

    session["selectcreateorjoin"]["user"] = {
      "name" => params[:name],
      "icon" => params[:icon]
    }

    session["selectcreateorjoin"]["group"] = {
      "name"     => params[:group_name],
      "passcode" => params[:passcode]
    }

    redirect_to new_user_registration_path
  end
end