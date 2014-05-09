class LeagueMembershipsController < ApplicationController
  
  def new
  end
  
  def create
    @league = League.find_by_secret_sauce(params[:secret_sauce])
    @membership = LeagueMembership.new(:user_id => current_user.id, :league_id => @league.id)
    
    if @membership.save
      redirect_to @league
      flash[:notice] = "You have sucessfully joined #{@league.name}"
    else
      @membership.errors.full_messages
    end
  end

  def show
    @league = League.friendly.find(params[:league_id])
    @league_membership = LeagueMembership.find(params[:id])
    @current_league_membership = LeagueMembership.find_by_user_id_and_league_id(current_user.id, @league.id)
  end
  
  def edit
    @league = League.friendly.find(params[:league_id])
    @league_members = @league.league_memberships.map{|lm| lm if lm != @league_membership}.compact
    @league_membership = LeagueMembership.find(params[:id])
    validate_ownership(@league, @league_membership)
    
    @available_players = Player.all
    @active_players, @bench_players = @league_membership.get_active_and_bench_players
  end
  
  def update
    @league_membership = LeagueMembership.find(params[:id])
    success = true
    RosterMembership.transaction do
      params[:roster_changes].each do |roster_id, active_boolean|
        current_roster = RosterMembership.find(roster_id)
        unless current_roster.update_attributes(:active => active_boolean)
          success = false
        end
      end
      
      if @league_membership.roster_memberships.where(:active => true).count != 4
        flash[:notice] = "Invalid Roster, please try again"
        success = false
        raise ActiveRecord::Rollback
      end
    end
    
    if success == true
      flash[:notice] = "Roster updated successfully"
      render status: 200
    else
      flash[:errors] = "Invalid Roster, please try again"
      render status: 500
    end
  end  
  
  def players
    league_membership = LeagueMembership.find(params[:tradee])
    resp = []
    league_membership.players.each do |player|
      resp << build_player_resp(player)
    end
    render text: resp.join("\n").html_safe
  end
  
  def build_player_resp(player)
    "<li data-id='#{player.id}' class='list-group-item selectable-resp'>
    <img src='#{player.picture_url}' width=40>#{player.name}</li>"
  end
  
  protected
  def validate_ownership(league, league_membership)
    current_membership = LeagueMembership.find_by_user_id_and_league_id(current_user.id, league.id)
    redirect_to league unless league_membership == current_membership
  end
end
