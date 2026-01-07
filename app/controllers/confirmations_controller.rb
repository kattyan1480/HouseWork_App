class ConfirmationsController < Devise::ConfirmationsController
  def show
    super do |user|
      data = session.dig("selectcreateorjoin", "group")
      mode = session.dig("selectcreateorjoin", "mode")

      next unless data && mode

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

      user.update!(group: group)

      session.delete("selectcreateorjoin")
    end
  end
end

