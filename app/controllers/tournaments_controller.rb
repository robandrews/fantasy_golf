class TournamentsController < ApplicationController
  def show
    @tournament = Tournament.find(params[:id])
    # find a way to get the players for these without having n+1 queries
  end
end
