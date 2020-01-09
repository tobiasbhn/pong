require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pong
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # config.after_initialize do
    #   # Clear some Models after Init
    #   Consumer.destroy_all
    #   Game.destroy_all
    #   User.destroy_all

    #   # Save Server Start Time to validate Cookies and Calc Uptime
    #   Pong::BOOTED_AT = Time.now
    #   puts "Server started at: " + Pong::BOOTED_AT.to_s
    # end
  end
end
