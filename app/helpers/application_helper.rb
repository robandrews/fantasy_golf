module ApplicationHelper
  def current_week
    Week.find(20)
  end
  
  def settle_offer(offer)
    interested_parties = offer.interested_parties
    if interested_parties.length == 1
      RosterMembership.transaction do
        lm = LeagueMembership.find(interested_parties.first.league_membership_id)
        RosterMembership.create!(:league_membership_id => lm.id,
        :player_id => offer.player_id,
        :league_id => lm.league_id)
        
        offer.update_attributes(:completed => true)
        
        lm.ready = false
        lm.monthly_fa_pickups += 1
        lm.season_fa_pickups += 1
        lm.save!
      end
    else
      # bid_hash = {}
   #    
   #          offer.interested_parties.each do |ip|
   #            bid_hash[ip.id] = ip.free_agent_bids
   #          end
    end
  end
end
