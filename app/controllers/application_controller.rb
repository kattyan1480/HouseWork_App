class ApplicationController < ActionController::Base
  before_action :redirect_if_group_not_set
  helper_method :show_footer?

  private

  def redirect_if_group_not_set
    return unless user_signed_in?
    return if current_user.group_id.present?
    return if controller_name == "selectcreateorjoin"

    redirect_to selectcreateorjoin_select_path
  end

  def show_footer?
    footer_pages = {
      "homes"  => %w[index],
      "chores" => %w[index history]
    }

    footer_pages[controller_name]&.include?(action_name)
  end
end
