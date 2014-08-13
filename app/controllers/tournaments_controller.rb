class TournamentsController < ApplicationController

  def index
    
  end

  def show
    @tournament = Tournament.find(params[:id])
    @season = Season.friendly.find(params[:season_id])
    @league = League.friendly.find(params[:league_id])
    @players = {}
    @id_matcher = {}
    @tournament.players.each do |player|
      @players[player.yahoo_id] = player.name
      @id_matcher[player.yahoo_id] = Player.find_by_yahoo_id(player.yahoo_id).id
    end
  end
  
  def new
    
  end
  
  def create
    
  end
  
end
