namespace :score do
  desc "Score league data"
  task week: :environment do
    current_date = Date.parse(Time.now.to_s)
    season = Season.where("start_date < ? AND end_date > ?", current_date, current_date).take
    week = Week.where("season_id = ? AND week_order = ?", season.id, FantasyGolf::Application::CURRENT_WEEK).take
    leagues = League.all
    League.all.each do |league|
      league.members.each do |member|
        member.players.each do |player|
          member_week_points = 0
          week.tournaments.each do |tournament|
            p tournament
            standings = TournamentStanding.where("player_id = ? AND tournament_id = ?", player.yahoo_id, tournament.id)
            p standings
            standings.each do |standing|
              p standing
              member_week_points += standing.fantasy_points
            end
          end
          new_pts = member.season_points + member_week_points
          member.update_attributes(:season_points => new_pts)
        end
      end
    end
  end
end