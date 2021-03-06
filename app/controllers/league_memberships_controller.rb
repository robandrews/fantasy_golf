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
    @active_players, @bench_players = @league_membership.get_active_and_bench_players
  end
  
  def edit
    @league = League.friendly.find(params[:league_id])
    @league_membership = LeagueMembership.find(params[:id])
    @league_members = @league.league_memberships.map{|lm| lm if lm != @league_membership}.compact
    
    validate_ownership(@league, @league_membership)
    taken = []
    @league.league_memberships.each do |lm|
      lm.players.each do |player|
        taken << player.id
      end
    end

    @available_players = Player.where('id not in (?)',taken)
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
      
      # a valid roster should have no more than 7 players
      if @league_membership.roster_memberships.count > 7
        flash[:notice] = "Invalid Roster, you must have no more than 7 players on the roster."
        success = false
        raise ActiveRecord::Rollback
      end
      
      # check for correct number of active players
      if @league_membership.roster_memberships.where(:active => true).count != 4
        flash[:notice] = "Invalid Roster, you must have exactly 4 active players."
        success = false
        raise ActiveRecord::Rollback
      end
      
      @league_membership.update_attributes(:ready => true)
    end
    
    if success == true
      flash[:notice] = "Roster updated successfully"
      render status: 200
    else
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
  
  def droppable_players
    league_membership = LeagueMembership.find(params[:tradee])
    resp = []
    league_membership.players.each do |player|
      resp << build_droppable_player_resp(player)
    end
    render text: resp.join("\n").html_safe
  end
  
  
  def score
    league_membership = LeagueMembership.find(params[:league_membership_id])
    render json: league_membership.season_points, status: :ok
  end

  def season_scores
    @league_membership = LeagueMembership.find(params[:league_membership_id])
    render partial: "league_memberships/score_table", status: :ok
  end
  
  def build_player_resp(player)
    "<li data-id='#{player.id}' class='list-group-item selectable-resp'>
    <img src='#{player.picture_url}' width=40>#{player.name}</li>"
  end
  
  def build_droppable_player_resp(player)
    "<li data-id='#{player.id}' class='list-group-item selectable-resp'>
    <img src='#{player.picture_url}' width=40>#{player.name}
    <button class='btn btn-sm btn-danger pull-right delete-roster-membership' style='margin-top:10px;' data-id='#{player.id}'>
    Drop</button></li>
"
  end
  
  def update_scores
    @lm = LeagueMembership.find(params[:league_membership_id])
    @lm.season_scores = JSON.parse(params[:season_scores]).map{|el| [el[0], el[1].to_f]}.to_json
    @lm.season_points = @lm.calculate_season_points_from_season_scores
    if @lm.save
      flash[:notice] = "Score updated successfully"
      render json: :nothing, status: 200
    else
      render @lm.errors.full_messages, status: :unprocessable_entity
    end
  end

  protected
  def validate_ownership(league, league_membership)
    current_membership = LeagueMembership.find_by_user_id_and_league_id(current_user.id, league.id)
    redirect_to league unless league_membership == current_membership
  end
end
