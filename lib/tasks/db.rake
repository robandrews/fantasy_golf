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
  end
  
  
  desc "Seed all tournaments"
  task tournament_seed: :environment do
    
    tournament_data = [
      {:name=>"Hyundai Tournament of Champions",
      :url => "https://sports.yahoo.com/golf/pga/leaderboard/2014/1",
      :start_date => Date.new(2014, 1, 3),
      :end_date => Date.new(2014, 1, 6)},
    
      {:name=>"Shell Houston Open",
      :url => "https://sports.yahoo.com/golf/pga/leaderboard/2014/18",
      :start_date => Date.new(2014, 4, 3),
      :end_date => Date.new(2014, 4, 6)},
    
    
      {:name=>"The Masters",
      :url => "https://sports.yahoo.com/golf/pga/leaderboard/2014/15",
      :start_date => Date.new(2014, 4, 10),
      :end_date => Date.new(2014, 4, 13)},
    
      {:name=>"Valero Texas Open",
      :url => "https://sports.yahoo.com/golf/pga/leaderboard/2014/44",
      :start_date => Date.new(2014, 3, 27),
      :end_date => Date.new(2014, 3, 30)},
      
      {:name=>"RBC Heritage",
      :url => "https://sports.yahoo.com/golf/pga/leaderboard/2014/16",
      :start_date => Date.new(2014, 4, 17),
      :end_date => Date.new(2014, 4, 20)}    
    ]
    
    
    tournament_data.each do |tournament|
      time = Time.now
      tournament["complete"] = tournament[:end_date] < Date.new(time.year, time.month, time.day)
      Tournament.create!(tournament)
    end
  end
end
