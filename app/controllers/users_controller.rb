class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    # this will eventually need to be a more sophisticated SQL query to weed out players who are already taken
    @available_players = Player.all
    
    @league_id = params[:league_id]
    active = @user.roster_memberships.where(:active => true)
    bench = @user.roster_memberships.where(:active => false)
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
    @user = User.find(params[:id])
    success = true
    RosterMembership.transaction do
      params[:roster_changes].each do |roster_id, active_boolean|
        current_roster = RosterMembership.find(roster_id)
        unless current_roster.update_attributes(:active => active_boolean)
          success = false
        end
      end
      
      if @user.roster_memberships.where(:active => true).count != 4
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
end
