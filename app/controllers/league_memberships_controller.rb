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

  def edit
    @available_players = Player.all
    @league_membership = LeagueMembership.find(params[:id])
    @league = League.friendly.find(params[:league_id])
    @league_members = @league.league_memberships.map{|lm| lm if lm != @league_membership}.compact
    active = @league_membership.roster_memberships.where(:active => true)
    bench = @league_membership.roster_memberships.where(:active => false)
    @active_players = {}
    @bench_players = {}
    
    active.each do |roster_membership|
      @active_players[roster_membership] = Player.find(roster_membership.player_id)
    end
    
    bench.each do |roster_membership|
      @bench_players[roster_membership] = Player.find(roster_membership.player_id)
    end

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
    p params
    league_membership = LeagueMembership.find(params[:tradee])
    resp = []
    league_membership.players.each do |player|
      resp << build_player_resp(player)
    end
    render text: resp.join("\n").html_safe
  end
  
  def build_player_resp(player)
    "<li data-id='#{player.id}' class='list-group-item selectable-resp'>
    <img src='#{player.picture_url}' width=40>#{player.name}</li><br />"
  end
  
end
