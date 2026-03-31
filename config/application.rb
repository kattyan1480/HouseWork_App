require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module HouseworkApp
  class Application < Rails::Application
    config.load_defaults 7.0

    config.i18n.default_locale = :ja
    config.time_zone = "Tokyo"
    config.active_record.default_timezone = :utc

    config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }
  end
end
