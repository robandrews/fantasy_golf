namespace :archive do
  desc "Archive league data"
  
  task week: :environment do
    League.all.each do |league|
      
      member_rosters = {}
      
      league.members.each do |member|
        member_rosters[member.id] = member.players.to_json
      end
      
      current_date = Date.parse(Time.now.to_s)
      season = Season.where("start_date < ? AND end_date > ?", current_date, current_date).take
      week = Week.where("season_id = ? AND week_order = ?", season.id, FantasyGolf::Application::CURRENT_WEEK).take
      ArchivedWeek.create!(:roster => member_rosters.to_json, 
                          :league_id => league.id, 
                          :season_id => season.id,
                          :week_id => week.id)        
    end
  end
  
end