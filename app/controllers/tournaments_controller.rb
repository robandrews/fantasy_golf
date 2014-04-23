class TournamentsController < ApplicationController
  def show
    @tournament = Tournament.find(params[:id])
    @players = {}
    @tournament.players.each do |player|
      @players[player.yahoo_id] = player.name
    end
  end
  
end
