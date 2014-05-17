require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :cron do
  desc "Free agent check"
  task fa: :environment do
    # fill this out
  end
end

