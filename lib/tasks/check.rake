namespace :check do
  
  desc "Check for expired free agent offers"
  task expired: :environment do
    expired = FreeAgentOffer.where("expiry_date < ?", DateTime.now)
    
    FreeAgentOffer.transaction do
      # decide who gets the players, create the roster memberships.
    end
  end
  
end