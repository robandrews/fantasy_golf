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

Tournament.create(:name => "Hyundai", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/1",
:start_date => DateTime.new(2014, 1, 3, 14, 0, 0),
:end_date => DateTime.new(2014, 1, 6, 7, 0, 0),
:week_id => weeks[1].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "Sony Open", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/7",
:start_date => DateTime.new(2014, 1, 9, 14, 0, 0),
:end_date => DateTime.new(2014, 1, 12, 7, 0, 0),
:week_id => weeks[2].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "Humana", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/3",
:start_date => DateTime.new(2014, 1, 16, 14, 0, 0),
:end_date => DateTime.new(2014, 1, 19, 7, 0, 0),
:week_id => weeks[3].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "Farmers", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/6",
:start_date => DateTime.new(2014, 1, 23, 14, 0, 0),
:end_date => DateTime.new(2014, 1, 26, 7, 0, 0),
:week_id => weeks[4].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "Waste Management", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/4",
:start_date => DateTime.new(2014, 1, 30, 14, 0, 0),
:end_date => DateTime.new(2014, 2, 2, 7, 0, 0),
:week_id => weeks[5].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "AT&T Pebble Beach", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/5",
:start_date => DateTime.new(2014, 2, 6, 14, 0, 0),
:end_date => DateTime.new(2014, 2, 9, 7, 0, 0),
:week_id => weeks[6].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "Northern Trust Open", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/8",
:start_date => DateTime.new(2014, 2, 13, 14, 0, 0),
:end_date => DateTime.new(2014, 2, 16, 7, 0, 0),
:week_id => weeks[7].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "WCG Accenture", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/174",
:start_date => DateTime.new(2014, 2, 13, 14, 0, 0),
:end_date => DateTime.new(2014, 2, 16, 7, 0, 0),
:week_id => 8,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "Honda Classic", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/10",
:start_date => DateTime.new(2014, 2, 27, 14, 0, 0),
:end_date => DateTime.new(2014, 3, 2, 7, 0, 0),
:week_id => weeks[9].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "Puerto Rico Open", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/380",
:start_date => DateTime.new(2014, 3, 6, 14, 0, 0),
:end_date => DateTime.new(2014, 3, 9, 7, 0, 0),
:week_id => weeks[10].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "Valspar Championship", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/104",
:start_date => DateTime.new(2014, 3, 13, 14, 0, 0),
:end_date => DateTime.new(2014, 3, 16, 7, 0, 0),
:week_id => weeks[11].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "Arnold Palmer", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/11",
:start_date => DateTime.new(2014, 3, 20, 14, 0, 0),
:end_date => DateTime.new(2014, 3, 23, 7, 0, 0),
:week_id => weeks[12].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "Valero Texas Open", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/44",
:start_date => DateTime.new(2014, 3, 27, 14, 0, 0),
:end_date => DateTime.new(2014, 3, 30, 7, 0, 0),
:week_id => weeks[13].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "Shell Houston Open", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/18",
:start_date => DateTime.new(2014, 4, 3, 14, 0, 0),
:end_date => DateTime.new(2014, 4, 6, 7, 0, 0),
:week_id => weeks[14].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "The Masters", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/15",
:start_date => DateTime.new(2014, 4, 10, 14, 0, 0),
:end_date => DateTime.new(2014, 4, 13, 7, 0, 0),
:week_id => weeks[15].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "RBC Heritage", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/16",
:start_date => DateTime.new(2014, 4, 17, 14, 0, 0),
:end_date => DateTime.new(2014, 4, 20, 7, 0, 0),
:week_id => weeks[16].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "Zurich Classic", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/12",
:start_date => DateTime.new(2014, 4, 24, 14, 0, 0),
:end_date => DateTime.new(2014, 4, 27, 7, 0, 0),
:week_id => weeks[17].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "Wells Fargo Championship", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/290",
:start_date => DateTime.new(2014, 5, 1, 14, 0, 0),
:end_date => DateTime.new(2014, 5, 4, 7, 0, 0),
:week_id => weeks[18].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "The Players Championship", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/13",
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

Tournament.create(:name => "U.S. Open", :url => "https://sports.yahoo.com/golf/pga/leaderboard/2014/24",
:start_date => DateTime.new(2014, 6, 12, 14, 0, 0),
:end_date => DateTime.new(2014, 6, 15, 7, 0, 0),
:week_id => weeks[24].id,
:complete => :false,
:multiplier => 1.5)


Tournament.create(:name => "Travelers", :url => "https://sports.yahoo.com/golf/pga/leaderboard/2014/26",
:start_date => DateTime.new(2014, 6, 19, 14, 0, 0),
:end_date => DateTime.new(2014, 6, 22, 7, 0, 0),
:week_id => weeks[25].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "Quicken Loans National", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/375",
:start_date => DateTime.new(2014, 6, 26, 14, 0, 0),
:end_date => DateTime.new(2014, 6, 29, 7, 0, 0),
:week_id => weeks[26].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "The Greenbriar Classic", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/401",
:start_date => DateTime.new(2014, 7, 3, 14, 0, 0),
:end_date => DateTime.new(2014, 7, 6, 7, 0, 0),
:week_id => weeks[27].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "John Deere Classic", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/39",
:start_date => DateTime.new(2014, 7, 10, 14, 0, 0),
:end_date => DateTime.new(2014, 7, 13, 7, 0, 0),
:week_id => weeks[28].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "The Open Championship", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/29",
:start_date => DateTime.new(2014, 7, 17, 14, 0, 0),
:end_date => DateTime.new(2014, 7, 20, 7, 0, 0),
:week_id => weeks[29].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "RBC Canadian Open", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/38",
:start_date => DateTime.new(2014, 7, 24, 14, 0, 0),
:end_date => DateTime.new(2014, 7, 27, 7, 0, 0),
:week_id => weeks[30].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "WCG-Bridgestone", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/35",
:start_date => DateTime.new(2014, 7, 31, 14, 0, 0),
:end_date => DateTime.new(2014, 8, 3, 7, 0, 0),
:week_id => weeks[31].id,
:complete => :true,
:multiplier => 1.0)

	Tournament.create(:name => "Reno-Tahoe Open", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/232",
:start_date => DateTime.new(2014, 7, 31, 14, 0, 0),
:end_date => DateTime.new(2014, 8, 3, 7, 0, 0),
:week_id => weeks[31].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "PGA Championship", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/33",
:start_date => DateTime.new(2014, 8, 7, 14, 0, 0),
:end_date => DateTime.new(2014, 8, 10, 7, 0, 0),
:week_id => weeks[32].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "Wyndham Championship", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/17",
:start_date => DateTime.new(2014, 8, 14, 14, 0, 0),
:end_date => DateTime.new(2014, 8, 17, 7, 0, 0),
:week_id => weeks[33].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "Barclays", :url => "",
:start_date => DateTime.new(2014, 8, 21, 14, 0, 0),
:end_date => DateTime.new(2014, 8, 24, 7, 0, 0),
:week_id => weeks[34].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "Deutsche Banke Championship", :url => "",
:start_date => DateTime.new(2014, 8, 29, 14, 0, 0),
:end_date => DateTime.new(2014, 9, 1, 7, 0, 0),
:week_id => weeks[35].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "BMW Championship", :url => "",
:start_date => DateTime.new(2014, 9, 4, 14, 0, 0),
:end_date => DateTime.new(2014, 9, 7, 7, 0, 0),
:week_id => weeks[36].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "Tour Championship", :url => "",
:start_date => DateTime.new(2014, 9, 11, 14, 0, 0),
:end_date => DateTime.new(2014, 9, 14, 7, 0, 0),
:week_id => weeks[37].id,
:complete => :true,
:multiplier => 1.0)

Tournament.create(:name => "Ryder Cup", :url => "",
:start_date => DateTime.new(2014, 9, 26, 14, 0, 0),
:end_date => DateTime.new(2014, 9, 28, 7, 0, 0),
:week_id => weeks[38].id,
:complete => :true,
:multiplier => 1.0)


print "#######################################################\n"
print "Finished seeding database in #{Time.now - start} seconds"
print "#######################################################\n"

