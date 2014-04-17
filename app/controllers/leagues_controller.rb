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
      flash[:errors] = @league.errors.full_messages
    end
  end
  
  def show
    @league = League.find(params[:id])
  end
  
  protected
  def league_params
    params.require(:league).permit(:name)
  end
end
