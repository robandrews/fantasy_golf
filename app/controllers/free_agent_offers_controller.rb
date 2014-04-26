class FreeAgentOffersController < ApplicationController
  
  def create
    player = Player.find(params[:player_id])
    offer = FreeAgentOffer.new(:player_id => player.id, :name => player.name,
                               :expiry_date => 12.hours.from_now,
                               :user_name => current_user.name)
    offer.interested_parties.build(:user_id => current_user.id)
    
    if offer.save
      # redirect_to :controller => "FreeAgentOffers", :actions => "get", :id => params[:league_id]
      redirect_to league_free_agent_offers_url
    else
      flash[:errors] = "Unable to process free agent request at this time"
      redirect_to :back
    end
  end
  
  def index
    @offers = FreeAgentOffer.all
  end
end
