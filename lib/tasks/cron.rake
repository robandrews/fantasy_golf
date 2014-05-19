require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :cron do
  desc "Free agent check"
  task fa: :environment do
    current_date = DateTime.parse(Time.now.to_s)
    League.all.each do |league|
      offers = FreeAgentOffer.where("league_id = ? AND expiry_date < ? AND completed = false", league.id, current_date)
      unless offers.empty?
        offers.each do |offer|
          settle_offer(offer)
        end
      end
    end
  end
end

