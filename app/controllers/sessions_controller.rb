class SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate(auth_options)

      if resource
          set_flash_message!(:notice, :signed_in)
          sign_in(resource_name, resource)
          redirect_to after_sign_in_path_for(resource), status: :see_other
      else
      self.resource = resource_class.new(sign_in_params)

      # 個別エラー設定
      resource.errors.add(:email, "を入力してください") if params[:user][:email].blank?
      resource.errors.add(:password, "を入力してください") if params[:user][:password].blank?

      if params[:user][:email].present? && params[:user][:password].present?
        resource.errors.add(:base, "メールアドレスまたはパスワードが正しくありません。")
      end

      clean_up_passwords(resource)
      render :new, status: :unprocessable_entity
    end
  end
end