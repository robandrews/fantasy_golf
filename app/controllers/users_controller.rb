class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    active = @user.roster_memberships.where(:active => true)
    bench = @user.roster_memberships.where(:active => false)
    @active_players = []
    @bench_players = []  
    active.each do |roster_membership|
      @active_players << Player.find(roster_membership.player_id)
    end
    
    bench.each do |roster_membership|
      @bench_players << Player.find(roster_membership.player_id)
    end

  end
end
