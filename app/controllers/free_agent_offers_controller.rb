class FreeAgentOffersController < ApplicationController
  
  def create
    @league = League.friendly.find(params[:league_id])
    player = Player.find(params[:player_id])
    league_membership = LeagueMembership.find_by_user_id_and_league_id(current_user.id, @league.id)
    
    offer = FreeAgentOffer.new(:player_id => player.id, :name => player.name,
                               :expiry_date => 12.hours.from_now,
                               :name => player.name,
                               :user_name => current_user.name,
                               :creator_league_membership_id => league_membership.id,
                               :league_id => @league.id)
    offer.interested_parties.build(:league_membership_id => league_membership.id)
    
    if offer.save
      redirect_to league_free_agent_offers_url
    else
      flash[:alert] = "Unable to process free agent request.  You are only allowed one bid per free agent."
      redirect_to :back
    end
  end
  
  def index
    @league = League.friendly.find(params[:league_id])
    @league_membership = LeagueMembership.find_by_user_id_and_league_id(current_user.id, @league.id)
    @offers = FreeAgentOffer.where("expiry_date > ?", DateTime.now)
  end
  
  def update
    @offer = FreeAgentOffer.find(params[:id])
    @league = League.friendly.find(params[:league_id])
    league_membership = LeagueMembership.find_by_user_id_and_league_id(current_user.id, @league.id)
    @offer.interested_parties.build(:league_membership_id => league_membership.id)
    if @offer.save
      flash[:notice] = "Bid submitted for #{@offer.name}"
      render status: 200
    else
      flash[:alert] = "Unable to process free agent request at this time"
      render status: 500
    end
  end
  
end
