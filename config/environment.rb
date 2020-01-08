# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# Clear some Models after Init
Consumer.destroy_all
Game.destroy_all
User.destroy_all