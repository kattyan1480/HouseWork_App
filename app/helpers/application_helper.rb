module ApplicationHelper
  def show_footer?
    footer_pages = {
      "homes"  => %w[index],
      "chores" => %w[index]
    }

    footer_pages[controller_name]&.include?(action_name)
  end
end

