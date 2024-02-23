require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
# require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AiJournal
  class Application < Rails::Application
    # There seems to be a bug in turbo-rails that causes an issue when ActionCable is not loaded.
    # This is a workaround to prevent ActionCable from being eager loaded when turbo-rails is loaded.
    Rails.autoloaders.once.do_not_eager_load("#{Turbo::Engine.root}/app/channels")

    config.generators.system_tests = nil
    config.active_storage.service = :local
    config.time_zone = "Eastern Time (US & Canada)"
  end
end
