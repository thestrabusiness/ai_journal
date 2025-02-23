require_relative "boot"

require "rails"
# Pick the frameworks you want:

# require "active_job/railtie"
# require "action_mailbox/engine"
# require "action_cable/engine"
# require "rails/test_unit/railtie"
# require "active_storage/engine"

require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_text/engine"
require "action_view/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AiJournal
  class Application < Rails::Application
    # There seems to be a bug in turbo-rails that causes an issue when ActionCable is not loaded.
    # This is a workaround to prevent ActionCable from being eager loaded when turbo-rails is loaded.
    Rails.autoloaders.once.do_not_eager_load("#{Turbo::Engine.root}/app/channels")

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    # config.autoload_lib(ignore: %w[assets tasks])

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.active_storage.service = :local
    config.time_zone = "Eastern Time (US & Canada)"
  end
end
