class PlayersController < ApplicationController
  def index
    @all_players = Player.all  
    @players = Player.order(:last_name).page params[:page]    
    respond_to do |format|
      format.html
      format.json {render :json => @all_players}
    end
  end
  
  def edit
    @player = Player.find(params[:id])
  end
  
  def update
    @player = Player.find(params[:id])
    if @player.update_attributes(player_params)
      flash[:notice] = "#{@player.name} successfully updated."
      redirect_to players_url
    else
      flash[:alert] = "#{@player.name} was NOT successfully updated"
      redirect_to players_url
    end
  end
  
  protected
  def player_params
    params.require(:player).permit(:first_name, :last_name, :url, :twitter)
  end
end
