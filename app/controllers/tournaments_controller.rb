class TournamentsController < ApplicationController
  def show
    @tournament = Tournament.find(params[:id])
    @players = {}
    @id_matcher = {}
    @tournament.players.each do |player|
      @players[player.yahoo_id] = player.name
      @id_matcher[player.yahoo_id] = Player.find_by_yahoo_id(player.yahoo_id).id
    end
    
  end
  
end
