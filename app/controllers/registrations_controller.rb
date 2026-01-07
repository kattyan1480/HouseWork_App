class RegistrationsController < Devise::RegistrationsController

  def create
    build_resource(sign_up_params)

    user_data = session.dig("selectcreateorjoin", "user")
    if user_data
      resource.name = user_data["name"]
      resource.icon = user_data["icon"]
    end

    if resource.save
      sign_up(resource_name, resource)
      redirect_to root_path, notice: "確認メールを送信しました"
    else
      render :new, status: :unprocessable_entity
    end
  end
end