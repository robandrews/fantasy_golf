module ApplicationHelper
  def current_week
    Week.find(22)
  end
  
  def settle_offer(offer)
    if interested_parties.length == 1
      awardee = LeagueMembership.find(interested_parties.first.league_membership_id)
    else   
      awardee = decide_fa_winner(offer)
    end
    award_free_agent(awardee, offer)
  end
  
  def decide_fa_winner(offer)
    if viable_bidders(offer).length == 1
      LeagueMembership.find(viable_bidders.first[0])
    else
      league_memberships = []
      viable_bidders.each do |id, numbids|
        league_memberships << LeagueMembership.find(id)
      end
      league_memberships.min_by{|lm| lm.season_points}
    end
  end
  
  def award_free_agent(league_membership, offer)
    RosterMembership.transaction do      
      RosterMembership.create!(:league_membership_id => league_membership.id,
      :player_id => offer.player_id,
      :league_id => league_membership.league_id)
      
      offer.update_attributes(:completed => true)
      
      league_membership.ready = false
      league_membership.monthly_fa_pickups += 1
      league_membership.season_fa_pickups += 1
      league_membership.save!
    end
  end
  
  def viable_bidders(offer)
    bid_hash = {}
    offer.interested_parties.each do |ip|
      bid_hash[ip.id] = ip.free_agent_bids
    end
    
    min_num_bids = bid_hash.values.min
    bid_hash.select{|id, bids| bids == min_num_bids}
  end
end
