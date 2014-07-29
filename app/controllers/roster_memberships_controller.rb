class RosterMembershipsController < ApplicationController
  before_action :is_admin?, :only => [:admin_delete, :create]
  
  def destroy
    @roster_membership = RosterMembership.find(params[:id])
    if @roster_membership.destroy
      flash[:notice] = "Successfully dropped"
      redirect_to :back
    end
  end
  
  def admin_delete
    @roster_membership = 
      RosterMembership.find_by_player_id_and_league_membership_id(params[:player_id], params[:league_membership_id])
    if @roster_membership.destroy
      render :json => :nothing, status: :ok
    else
      render :json => @roster_membership.errors.full_messages, status: :unprocessable_entity
    end
  end
  
  def create
    @rm = RosterMembership.new(:player_id => params[:player_id], :league_membership_id => params[:league_membership_id])
    debugger    
    if @rm.save
      render :json => :nothing, status: :ok
    else
      render :json => @rm.errors.full_messages, status: :unprocessable_entity
    end
  end
  
  private
  def is_admin?
    current_user.admin
  end
end
