class BylawsController < ApplicationController
  def index
    @league = League.friendly.find(params[:league_id])
    @league_membership = LeagueMembership.where("user_id = ? AND league_id = ?",
                                                current_user.id, @league.id).first
  end
end
