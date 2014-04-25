class PlayersController < ApplicationController
  def index
    @all_players = Player.all  
    @players = Player.order(:last_name).page params[:page]    
    respond_to do |format|
      format.html
      format.json {render :json => @all_ players}
    end
  end
end
