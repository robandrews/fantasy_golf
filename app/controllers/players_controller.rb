class PlayersController < ApplicationController
  def index    
    @players = Player.order(:last_name).page params[:page]
  end
end
