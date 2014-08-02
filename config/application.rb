# figure out how to fix this stupid heroku thing
# config.assets.initialize_on_precompile = false


require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module FantasyGolf
  class Application < Rails::Application
    
    config.time_zone = 'Pacific Time (US & Canada)'
    config.i18n.enforce_available_locales = true    
    config.assets.enabled = true
    config.assets.paths << "#{Rails.root}/vendor/assets/fonts"
  end
end
