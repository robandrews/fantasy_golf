class BylawsController < ApplicationController
  def index
    @league = League.friendly.find(params[:league_id])
    @league_membership = LeagueMembership.find_by_user_id_and_league_id(current_user.id, @league.id)
  end
end
