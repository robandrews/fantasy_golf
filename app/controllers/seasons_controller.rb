class SeasonsController < ApplicationController
  def show
    @season = Season.friendly.find(params[:id])
    @league = League.friendly.find(params[:league_id])
  end

  def index
  	@seasons = Season.all
  	@league = League.friendly.find(params[:league_id])
  end
end
