class FreeAgentOffersController < ApplicationController
  
  def create
    @league = League.friendly.find(params[:league_id])
    player = Player.find(params[:player_id])
    league_membership = LeagueMembership.where("user_id = ? AND league_id = ?",
                                                current_user.id, @league.id).first
    offer = FreeAgentOffer.new(:player_id => player.id, :name => player.name,
                               :expiry_date => 12.hours.from_now,
                               :name => player.name,
                               :user_name => current_user.name)
    offer.interested_parties.build(:league_membership_id => league_membership.id)
    
    if offer.save
      redirect_to league_free_agent_offers_url
    else
      flash[:errors] = "Unable to process free agent request at this time"
      redirect_to :back
    end
  end
  
  def index
    @offers = FreeAgentOffer.where("expiry_date > ?", DateTime.now)
  end
end
