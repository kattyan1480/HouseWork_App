class ApplicationController < ActionController::Base
  before_action :redirect_if_group_not_set
  helper_method :show_footer?
  helper_method :current_group

  def current_group
    current_user.group
  end

  def after_sign_out_path_for(resource_or_scope)
    selectcreateorjoin_select_path
  end

  private

  def redirect_if_group_not_set
    return unless user_signed_in?
    return if current_user.group_id.present?
    return if controller_name == "selectcreateorjoin"

    redirect_to selectcreateorjoin_select_path
  end

  def show_footer?
    footer_pages = {
      "homes"  => %w[index previous],
      "chores" => %w[index history new],
      "achievements" => %w[index],
      "rewards" => %w[new edit],
      "profile" => %w[index]
    }

    footer_pages[controller_name]&.include?(action_name)
  end
end
