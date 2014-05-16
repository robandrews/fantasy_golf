require 'open-uri'
start = Time.now


season = Season.create(:name => "2013-2014", 
:start_date => Date.new(2014, 1, 3),
:end_date => Date.new(2014, 9, 28))

weeks = {}
(1..32).each do |w|
  weeks[w] = Week.create(:week_order => w, :season_id => season.id)
end
# 
# Tournament.create(:name => "Sony Open", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/7",
# :start_date => Date.new(2014, 1, 9),
# :end_date => Date.new(2014, 1, 12),
# :week_id => weeks[2].id,
# :complete => :true)
# 
# Tournament.create(:name => "Humana Challenge", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/3",
# :start_date => Date.new(2014, 1, 16),
# :end_date => Date.new(2014, 1, 19),
# :week_id => weeks[3].id,
# :complete => :true)
# 
# Tournament.create(:name => "Farmers", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/6",
# :start_date => Date.new(2014, 1, 23),
# :end_date => Date.new(2014, 1, 26),
# :week_id => weeks[4].id,
# :complete => :true)
# 
# Tournament.create(:name => "WM Phoenix Open", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/4",
# :start_date => Date.new(2014, 1, 30),
# :end_date => Date.new(2014, 2, 2),
# :week_id => weeks[5].id,
# :complete => :true)
# 
# 
# Tournament.create(:name => "Pebble Beach", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/5",
# :start_date => Date.new(2014, 2, 6),
# :end_date => Date.new(2014, 2, 9),
# :week_id => weeks[6].id,
# :complete => :true)
# 
# Tournament.create(:name => "Northern Trust", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/8",
# :start_date => Date.new(2014, 2, 13),
# :end_date => Date.new(2014, 2, 16),
# :week_id => weeks[7].id,
# :complete => :true)

Tournament.create(:name => "Players Championship", :url => "https://sports.yahoo.com/golf/pga/leaderboard/2014/13",
:start_date => DateTime.new(2014, 5, 8, 14, 0, 0),
:end_date => DateTime.new(2014, 5, 11, 7, 0, 0),
:week_id => weeks[20].id,
:complete => :true)


Tournament.create(:name => "HP Byron Nelson", :url => "https://sports.yahoo.com/golf/pga/leaderboard/2014/19",
:start_date => DateTime.new(2014, 5, 15, 14, 0, 0),
:end_date => DateTime.new(2014, 5, 19, 7, 0, 0),
:week_id => weeks[21].id,
:complete => :true)

Tournament.create(:name => "Crown Plaza Invitational", :url => "",
:start_date => DateTime.new(2014, 5, 22, 14, 0, 0),
:end_date => DateTime.new(2014, 5, 25, 7, 0, 0),
:week_id => weeks[22].id,
:complete => :true)


print "#######################################################\n"
print "Finished seeding database in #{Time.now - start} seconds"
print "#######################################################\n"
