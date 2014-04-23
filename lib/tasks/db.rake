namespace :db do
  desc "Seed all the players from Yahoo! Golf database"
  task player_seed: :environment do
    ('a'..'y').each do |letter|            
      url = "http://sports.yahoo.com/golf/pga/players?lname=#{letter}"
      page = Nokogiri::HTML(RestClient.get(url))

      page.css("#playerResult").css("a").each do |link|
        attrs = {}
  
        url = "http://sports.yahoo.com" + link["href"]
    
        puts "scraping #{url}"
    
        attrs["url"] = url
        attrs["yahoo_id"] = url.match(/\A\D+(\d+)\z/)[1].to_i
        attrs["first_name"], attrs["last_name"] = link.text.split(" ")
  
        page = Nokogiri::HTML(RestClient.get(url))
        attrs["picture_url"] = page.css("div.playerPhoto").css("img").attr("src").value
        stats = page.css("div.playerStats").css("li")
        stats.each do |stat|
          if stat.css("em").text == "Height:"
            height = stat.css("span").text.split("-")
            attrs["height"] = height[0].to_i*12 + height[1].to_i
          elsif stat.css("em").text == "Weight:"
            attrs["weight"] = stat.css("span").text.to_i
          elsif stat.css("em").text == "College:"
            attrs["college"] = stat.css("span").text
          elsif stat.css("em").text == "Birth Place:"
            attrs["birth_place"] = stat.css("span").text
          elsif stat.css("em").text == "Career Earnings:"  
            attrs["career_earnings"] = 
                stat.css("span").text.match(/\A\$([\d|,]+)\z/)[1].gsub(",","").to_i
          elsif stat.css("em").text == "Born:"
            str, m, d, yr = stat.css("span").text.match(/(\d+)\/(\d+)\/(\d+)/).to_a
            yr.prepend("19")
            attrs["birthdate"] = Date.new(yr.to_i, m.to_i, d.to_i)
          end
        end
        p Player.create(attrs)
      end
    end
    
    missing_urls = 
          ["http://sports.yahoo.com/golf/pga/players/Dustin+Johnson/9267"]
    
    missing_urls.each do |url|
      Player.build_from_url(url)
    end   
  end
  
  
  desc "Seed all tournaments"
  task season_seed: :environment do
    Tournament.delete_all
    TournamentStanding.delete_all
    Season.delete_all
    Week.delete_all
    
    season = Season.create!(:name => "2014", 
    :start_date => Date.new(2014, 1, 3),
    :end_date => Date.new(2014, 9, 28))

    weeks = {}
    (1..16).each do |w|
      weeks[w] = Week.create!(:week_order => w, :season_id => season.id)
    end
    
    
    tournament_data = [
      {:name => "Hyundai", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/1",
      :start_date => Date.new(2014, 1, 3),
      :end_date => Date.new(2014, 1, 6),
      :week_id => weeks[1].id},
    
      {:name => "Sony Open", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/7",
      :start_date => Date.new(2014, 1, 9),
      :end_date => Date.new(2014, 1, 12),
      :week_id => weeks[2].id,},
    
      {:name => "Humana Challenge", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/3",
      :start_date => Date.new(2014, 1, 16),
      :end_date => Date.new(2014, 1, 19),
      :week_id => weeks[3].id},
    
      {:name => "Farmers", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/6",
      :start_date => Date.new(2014, 1, 23),
      :end_date => Date.new(2014, 1, 26),
      :week_id => weeks[4].id},
      
      {:name => "WM Phoenix Open", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/4",
      :start_date => Date.new(2014, 1, 30),
      :end_date => Date.new(2014, 2, 2),
      :week_id => weeks[5].id},
      
      {:name => "Pebble Beach", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/5",
      :start_date => Date.new(2014, 2, 6),
      :end_date => Date.new(2014, 2, 9),
      :week_id => weeks[6].id},
      
      {:name => "Northern Trust", :url => "http://sports.yahoo.com/golf/pga/leaderboard/2014/8",
      :start_date => Date.new(2014, 2, 13),
      :end_date => Date.new(2014, 2, 16),
      :week_id => weeks[7].id}
    ]
    
    tournament_data.each do |tournament|
      time = Time.now
      tournament["complete"] = tournament[:end_date] < Date.new(time.year, time.month, time.day)
      Tournament.create!(tournament)
    end
    
    Tournament.all.each do |tournament|
      tournament.get_scores
    end
  end
end
