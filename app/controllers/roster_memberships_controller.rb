class RosterMembershipsController < ApplicationController
  
  def destroy
    @roster_membership = RosterMembership.find(params[:id])
    if @roster_membership.destroy
      flash[:notice] = "Successfully dropped"
      redirect_to :back
    end
  end
end
