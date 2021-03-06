class LeaguesController < ApplicationController  
  def new
  end

  def create
    @league = League.new(league_params)
    if @league.save
      LeagueModeratorship.create!(:user_id => current_user.id, :league_id => @league.id)
      LeagueMembership.create!(:user_id => current_user.id, :league_id => @league.id)
      render :json => [@league, league_url(@league)]
    else
      flash[:alert] = @league.errors.full_messages
    end
  end

  def show
    @league = League.friendly.find(params[:id])
    @divisions = @league.divisions
    @league_membership = LeagueMembership.find_by_user_id_and_league_id(current_user.id, @league.id)
  end

  def bylaws
    @league = League.friendly.find(params[:league_id])
  end

  def admin
    @league = League.friendly.find(params[:league_id])
    @league_membership = LeagueMembership.find_by_user_id_and_league_id(current_user.id, @league.id)
    taken = []
    @league.league_memberships.each do |lm|
      lm.players.each do |player|
        taken << player.id
      end
    end
    @available_players = Player.where('id not in (?)',taken)
  end
  
  protected
  def league_params
    params.require(:league).permit(:name)
  end
end