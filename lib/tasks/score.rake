require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :score do
  desc "Score league data"
  
  task week: :environment do
    current_date = Date.parse(Time.now.to_s)
    season = Season.where("start_date < ? AND end_date > ?", current_date, current_date).take
    week = current_week
    player_scores = {}
    
    week.tournaments.each do |tournament|
      tournament.get_scores
    end
    
    League.all.each do |league|
      league.league_memberships.each do |league_membership|
        member_week_points = 0.0
        
        player_scores = Hash.new{|h, k| h[k]=0}
        
        week.tournaments.each do |tournament|
          
          league_membership.players.each do |player|
            standings = TournamentStanding.where("player_id = ? AND tournament_id = ?", player.yahoo_id, tournament.id)
            standings.each do |standing|
              player_scores[player] += (standing.fantasy_points * tournament.multiplier)
              member_week_points += standing.fantasy_points || 0
            end
          end
        end
        
        user = User.find(league_membership.user_id)
        msg = UserMailer.weekly_summary_email(user, league, player_scores)
        msg.deliver
        
        new_pts = league_membership.season_points + member_week_points
        league_membership.update_attributes(:season_points => new_pts)
      end
    end  
  end
  
  
end

