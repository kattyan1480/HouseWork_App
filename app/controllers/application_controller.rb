class ApplicationController < ActionController::Base
  helper_method :show_footer?
  helper_method :current_group

  def current_group
    current_user.group
  end

  def after_sign_in_path_for(resource)
    if resource.group_id.present?
      authenticated_root_path
    else
      selectcreateorjoin_select_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  private

  def show_footer?
    footer_pages = {
      "homes"  => %w[index previous],
      "chores" => %w[index history new],
      "achievements" => %w[index],
      "rewards" => %w[new edit],
      "profile" => %w[index],
      "categories" => %w[index new edit]
    }

    footer_pages[controller_name]&.include?(action_name)
  end
end
