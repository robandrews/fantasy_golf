require 'open-uri'
start = Time.now

season = Season.create(:name => "2013-2014", 
:start_date => Date.new(2014, 1, 3),
:end_date => Date.new(2014, 9, 28))

weeks = {}
time_zero = DateTime.new(2013, 12, 30, 0, 0, 0)
40.times do |w|
  start_week = time_zero + (7*w).days
  end_week = start_week + 7.days - 1.second
  weeks[w+1] = Week.create(:week_order => w+1, :season_id => season.id, :start_time => start_week, :end_time => end_week)
end

Tournament.create(:name => "Players Championship", :url => "https://sports.yahoo.com/golf/pga/leaderboard/2014/13",
:start_date => DateTime.new(2014, 5, 8, 14, 0, 0),
:end_date => DateTime.new(2014, 5, 11, 7, 0, 0),
:week_id => weeks[19].id,
:complete => :true,
:multiplier => 1.0)


Tournament.create(:name => "HP Byron Nelson", :url => "https://sports.yahoo.com/golf/pga/leaderboard/2014/19",
:start_date => DateTime.new(2014, 5, 15, 14, 0, 0),
:end_date => DateTime.new(2014, 5, 19, 7, 0, 0),
:week_id => weeks[20].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "Crown Plaza Invitational", :url => "https://sports.yahoo.com/golf/pga/leaderboard/2014/20",
:start_date => DateTime.new(2014, 5, 22, 14, 0, 0),
:end_date => DateTime.new(2014, 5, 25, 7, 0, 0),
:week_id => weeks[21].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "The Memorial", :url => "https://sports.yahoo.com/golf/pga/leaderboard/2014/22",
:start_date => DateTime.new(2014, 5, 29, 14, 0, 0),
:end_date => DateTime.new(2014, 6, 1, 7, 0, 0),
:week_id => weeks[22].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "FedEx/St. Jude", :url => "https://sports.yahoo.com/golf/pga/leaderboard/2014/25",
:start_date => DateTime.new(2014, 6, 5, 14, 0, 0),
:end_date => DateTime.new(2014, 6, 8, 7, 0, 0),
:week_id => weeks[23].id,
:complete => :true,
:multiplier => 1.0)




print "#######################################################\n"
print "Finished seeding database in #{Time.now - start} seconds"
print "#######################################################\n"
