require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module FantasyGolf
  class Application < Rails::Application
    CURRENT_WEEK = 1
    
    config.time_zone = 'Pacific Time (US & Canada)'
  end
end
