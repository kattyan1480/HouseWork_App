class Users::RegistrationsController < Devise::RegistrationsController

  def new
    # 表示用
    super
  end

  def create
    data = session[:selectcreateorjoin]&.dig("group")
    mode = session[:selectcreateorjoin]&.dig("mode")

    unless data
     redirect_to groups_selectcreateorjoin_select_path,
                alert: "グループ情報が見つかりません"
      return
    end

    group =
      if mode == "create"
        Group.create!(
          name: data["name"],
          passcode: data["passcode"]
        )
      else
        Group.find_by!(
          name: data["name"],
          passcode: data["passcode"]
        )
      end

    build_resource(sign_up_params)
    resource.group = group

    if resource.save
      session.delete("selectcreateorjoin")
      sign_up(resource_name, resource)
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
 end
end


