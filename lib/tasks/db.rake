namespace :db do
  desc "Seed all the players from Yahoo! Golf database"
  task player_seed: :environment do
    ('a'..'y').each do |letter|            
      url = "http://sports.yahoo.com/golf/pga/players?lname=#{letter}"
      page = Nokogiri::HTML(RestClient.get(url))

      page.css("#playerResult").css("a").each do |link|
        attrs = {}
  
        url = "http://sports.yahoo.com" + link["href"]
    
        puts "Scraping... #{url}"
    
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
          ["http://sports.yahoo.com/golf/pga/players/Dustin+Johnson/9267",
           "http://sports.yahoo.com/golf/pga/players/Nicholas+Thompson/8416",
           "http://sports.yahoo.com/golf/pga/players/11704"]
    
    missing_urls.each do |url|
      Player.construct_from_url(url)
    end
    
    Player.find_by_yahoo_id(6872).update_attributes(:last_name => "de Jonge")
    Player.find_by_yahoo_id(1685).update_attributes(:last_name => "Van Pelt")
    Player.find_by_yahoo_id(8073).update_attributes(:last_name => "Angel Carballo")
    Player.find_by_yahoo_id(553).update_attributes(:last_name => "Angel Jimenez")
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
  
  desc "Seed gunga galunga league"
  task gunga_seed: :environment do
    league = League.create(:name => "Dalai Lama Golf League")
    
    ben_hogan = Division.create(:name => "Ben Hogan", :league_id => league.id)
    bobby_jones = Division.create(:name => "Bobby Jones", :league_id => league.id)
    moe_norman = Division.create(:name => "Moe Norman", :league_id => league.id)
    horton_smith = Division.create(:name => "Horton Smith", :league_id => league.id)
    
    steve_doman = User.create(:first_name => "Steve", :last_name => "Doman", :email => "domansj18@yahoo.com",
    :password => "password", :password_confirmation => "password")
     
    steve_doman_league = LeagueMembership.create(:user_id => steve_doman.id, :league_id => league.id, :name => steve_doman.name,
    :season_scores => [[["Hyundai", 1], 303.0],
     [["Sony Open", 2], 97.5],
     [["Humana Challenge", 3], 336.7],
     [["Farmers", 4], 23.5],
     [["WM Phoenix Open", 5], 89.0],
     [["Pebble Beach", 6], 88.5],
     [["Northern Trust", 7], 154.0],
     [["Accenture Match Play", 8], 111.0],
     [["Honda", 9], 92.36],
     [["Caddy/PR", 10], 275.25],
     [["Valspar", 11], 150.67],
     [["Arnold Palmer", 12], 304.0],
     [["Valero", 13], 158.5],
     [["Shell Houston", 14], 26.0],
     [["Masters", 15], 308.0],
     [["RBC Heritage", 16], 165.25],
     [["Zurich Classic", 17], 0.0],
     [["Wells Fargo", 18], 218.63],
     [["The Players", 19], 498.75],
     [["HP Byron", 20], 71.0],
     [["Crowne Plaza", 21], 84.0]].to_json
    )
    DivisionMembership.create(:league_membership_id => steve_doman_league.id, :division_id => ben_hogan.id)

    RosterMembership.create(:league_membership_id => steve_doman_league.id, :player_id => 180, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => steve_doman_league.id, :player_id => 185, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => steve_doman_league.id, :player_id => 44, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => steve_doman_league.id, :player_id => 96, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => steve_doman_league.id, :player_id => 74, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => steve_doman_league.id, :player_id => 220, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => steve_doman_league.id, :player_id => 35, :active => false, :league_id => league.id)
    
    
    jake_oconner = User.create(:first_name => "Jake", :last_name => "O'Conner", :email => "woconnerj@gmail.com",
    :password => "password", :password_confirmation => "password")
 
    jake_oconner_league = LeagueMembership.create(:user_id => jake_oconner.id, :league_id => league.id, :name => jake_oconner.name,
    :season_scores => [[["Hyundai", 1], 151.5],
     [["Sony Open", 2], 503.67],
     [["Humana Challenge", 3], 187.0],
     [["Farmers", 4], 125.5],
     [["WM Phoenix Open", 5], 106.5],
     [["Pebble Beach", 6], 376.5],
     [["Northern Trust", 7], 188.5],
     [["Accenture Match Play", 8], 469.5],
     [["Honda", 9], 171.5],
     [["Caddy/PR", 10], 178.5],
     [["Valspar", 11], 0.0],
     [["Arnold Palmer", 12], 341.0],
     [["Valero", 13], 117.5],
     [["Shell Houston", 14], 340.14],
     [["Masters", 15], 528.0],
     [["RBC Heritage", 16], 65.0],
     [["Zurich Classic", 17], 120.0],
     [["Wells Fargo", 18], 101.55],
     [["The Players", 19], 447.0],
     [["HP Byron", 20], 78.5],
     [["Crowne Plaza", 21], 106.13]].to_json)
    DivisionMembership.create(:league_membership_id => jake_oconner_league.id, :division_id => ben_hogan.id)

    RosterMembership.create(:league_membership_id => jake_oconner_league.id, :player_id => 36, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => jake_oconner_league.id, :player_id => 380, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => jake_oconner_league.id, :player_id => 188, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => jake_oconner_league.id, :player_id => 85, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => jake_oconner_league.id, :player_id => 181, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => jake_oconner_league.id, :player_id => 59, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => jake_oconner_league.id, :player_id => 170, :active => false, :league_id => league.id)
    
    
    robert_acho = User.create(:first_name => "Robert", :last_name => "Acho", :email => "achorobe@gmail.com",
    :password => "password", :password_confirmation => "password")
     
    robert_acho_league = LeagueMembership.create(:user_id => robert_acho.id, :league_id => league.id, :name => robert_acho.name,
    :season_scores => [[["Hyundai", 1], 0.0],
     [["Sony Open", 2], 3.5],
     [["Humana Challenge", 3], 40.2],
     [["Farmers", 4], 46.0],
     [["WM Phoenix Open", 5], 185.0],
     [["Pebble Beach", 6], 130.0],
     [["Northern Trust", 7], 250.0],
     [["Accenture Match Play", 8], 737.63],
     [["Honda", 9], 160.61],
     [["Caddy/PR", 10], 483.38],
     [["Valspar", 11], 120.0],
     [["Arnold Palmer", 12], 137.38],
     [["Valero", 13], 0.0],
     [["Shell Houston", 14], 226.5],
     [["Masters", 15], 810.0],
     [["RBC Heritage", 16], 70.25],
     [["Zurich Classic", 17], 265.5],
     [["Wells Fargo", 18], 33.5],
     [["The Players", 19], 63.75],
     [["HP Byron", 20], 33.5],
     [["Crowne Plaza", 21], 175.0]].to_json)
    DivisionMembership.create(:league_membership_id => robert_acho_league.id, :division_id => ben_hogan.id)

    RosterMembership.create(:league_membership_id => robert_acho_league.id, :player_id => 239, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => robert_acho_league.id, :player_id => 106, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => robert_acho_league.id, :player_id => 382, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => robert_acho_league.id, :player_id => 141, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => robert_acho_league.id, :player_id => 174, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => robert_acho_league.id, :player_id => 115, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => robert_acho_league.id, :player_id => 320, :active => false, :league_id => league.id)    

    matt_alessi = User.create(:first_name => "Matt", :last_name => "Alessi", :email => "malessi12@gmail.com",
    :password => "password", :password_confirmation => "password")
     
    matt_alessi_league = LeagueMembership.create(:user_id => matt_alessi.id, :league_id => league.id, :name => matt_alessi.name,
    :season_scores => [[["Hyundai", 1], 228.0],
     [["Sony Open", 2], 11.5],
     [["Humana Challenge", 3], 169.0],
     [["Farmers", 4], 312.43],
     [["WM Phoenix Open", 5], 200.0],
     [["Pebble Beach", 6], 217.63],
     [["Northern Trust", 7], 38.0],
     [["Accenture Match Play", 8], 363.5],
     [["Honda", 9], 0.0],
     [["Caddy/PR", 10], 326.63],
     [["Valspar", 11], 182.0],
     [["Arnold Palmer", 12], 219.5],
     [["Valero", 13], 73.5],
     [["Shell Houston", 14], 96.0],
     [["Masters", 15], 286.0],
     [["RBC Heritage", 16], 79.0],
     [["Zurich Classic", 17], 250.0],
     [["Wells Fargo", 18], 97.0],
     [["The Players", 19], 228.25],
     [["HP Byron", 20], 125.0],
     [["Crowne Plaza", 21], 29.0]].to_json)
     
    DivisionMembership.create(:league_membership_id => matt_alessi_league.id, :division_id => ben_hogan.id)

    RosterMembership.create(:league_membership_id => matt_alessi_league.id, :player_id => 226, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => matt_alessi_league.id, :player_id => 396, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => matt_alessi_league.id, :player_id => 159, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => matt_alessi_league.id, :player_id => 171, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => matt_alessi_league.id, :player_id => 264, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => matt_alessi_league.id, :player_id => 206, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => matt_alessi_league.id, :player_id => 377, :active => false, :league_id => league.id)
    
    
    morgan_priestley = User.create(:first_name => "Morgan", :last_name => "Priestley", :email => "morgan.priestley@gmail.com",
    :password => "password", :password_confirmation => "password")
     
    morgan_priestley_league = LeagueMembership.create(:user_id => morgan_priestley.id, :league_id => league.id, :name => morgan_priestley.name,
    :season_scores => [[["Hyundai", 1], 225.5],
     [["Sony Open", 2], 109.67],
     [["Humana Challenge", 3], 42.5],
     [["Farmers", 4], 58.0],
     [["WM Phoenix Open", 5], 69.0],
     [["Pebble Beach", 6], 20.5],
     [["Northern Trust", 7], 138.5],
     [["Accenture Match Play", 8], 182.75],
     [["Honda", 9], 304.11],
     [["Caddy/PR", 10], 291.0],
     [["Valspar", 11], 111.5],
     [["Arnold Palmer", 12], 145.5],
     [["Valero", 13], 0.0],
     [["Shell Houston", 14], 120.4],
     [["Masters", 15], 298.0],
     [["RBC Heritage", 16], 0.0],
     [["Zurich Classic", 17], 35.27],
     [["Wells Fargo", 18], 33.5],
     [["The Players", 19], 155.25],
     [["HP Byron", 20], 0.0],
     [["Crowne Plaza", 21], 13.25]].to_json)
    DivisionMembership.create(:league_membership_id => morgan_priestley_league.id, :division_id => ben_hogan.id)

    RosterMembership.create(:league_membership_id => morgan_priestley_league.id, :player_id => 327, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => morgan_priestley_league.id, :player_id => 381, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => morgan_priestley_league.id, :player_id => 149, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => morgan_priestley_league.id, :player_id => 16, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => morgan_priestley_league.id, :player_id => 212, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => morgan_priestley_league.id, :player_id => 157, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => morgan_priestley_league.id, :player_id => 116, :active => false, :league_id => league.id)
    
    
    brian_lepine = User.create(:first_name => "Brian", :last_name => "LePine", :email => "brianlepine26@gmail.com",
    :password => "password", :password_confirmation => "password")
     
    brian_lepine_league = LeagueMembership.create(:user_id => brian_lepine.id, :league_id => league.id, :name => brian_lepine.name,
    :season_scores => [[["Hyundai", 1], 0.0],
     [["Sony Open", 2], 32.5],
     [["Humana Challenge", 3], 75.0],
     [["Farmers", 4], 157.6],
     [["WM Phoenix Open", 5], 15.0],
     [["Pebble Beach", 6], 52.0],
     [["Northern Trust", 7], 44.5],
     [["Accenture Match Play", 8], 368.63],
     [["Honda", 9], 169.61],
     [["Caddy/PR", 10], 267.75],
     [["Valspar", 11], 20.0],
     [["Arnold Palmer", 12], 103.13],
     [["Valero", 13], 110.5],
     [["Shell Houston", 14], 180.0],
     [["Masters", 15], 589.0],
     [["RBC Heritage", 16], 375.5],
     [["Zurich Classic", 17], 265.5],
     [["Wells Fargo", 18], 55.5],
     [["The Players", 19], 576.38],
     [["HP Byron", 20], 78.5],
     [["Crowne Plaza", 21], 193.74]].to_json)
    DivisionMembership.create(:league_membership_id => brian_lepine_league.id, :division_id => bobby_jones.id)

    RosterMembership.create(:league_membership_id => brian_lepine_league.id, :player_id => 118, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => brian_lepine_league.id, :player_id => 329, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => brian_lepine_league.id, :player_id => 53, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => brian_lepine_league.id, :player_id => 121, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => brian_lepine_league.id, :player_id => 201, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => brian_lepine_league.id, :player_id => 11, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => brian_lepine_league.id, :player_id => 232, :active => false, :league_id => league.id)
    
    will_predhomme = User.create(:first_name => "Will", :last_name => "Predhomme", :email => "will.predhomme@gmail.com",
    :password => "password", :password_confirmation => "password")
     
    will_predhomme_league = LeagueMembership.create(:user_id => will_predhomme.id, :league_id => league.id, :name => will_predhomme.name,
    :season_scores => [[["Hyundai", 1], 82.5],
     [["Sony Open", 2], 97.5],
     [["Humana Challenge", 3], 13.0],
     [["Farmers", 4], 420.5],
     [["WM Phoenix Open", 5], 150.0],
     [["Pebble Beach", 6], 130.0],
     [["Northern Trust", 7], 56.2],
     [["Accenture Match Play", 8], 315.0],
     [["Honda", 9], 9.5],
     [["Caddy/PR", 10], 117.0],
     [["Valspar", 11], 25.5],
     [["Arnold Palmer", 12], 6.0],
     [["Valero", 13], 133.0],
     [["Shell Houston", 14], 26.0],
     [["Masters", 15], 138.0],
     [["RBC Heritage", 16], 107.5],
     [["Zurich Classic", 17], 24.5],
     [["Wells Fargo", 18], 63.0],
     [["The Players", 19], 32.5],
     [["HP Byron", 20], 25.0],
     [["Crowne Plaza", 21], 10.25]].to_json)
    DivisionMembership.create(:league_membership_id => will_predhomme_league.id, :division_id => bobby_jones.id)

    RosterMembership.create(:league_membership_id => will_predhomme_league.id, :player_id => 76, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => will_predhomme_league.id, :player_id => 91, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => will_predhomme_league.id, :player_id => 88, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => will_predhomme_league.id, :player_id => 281, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => will_predhomme_league.id, :player_id => 219, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => will_predhomme_league.id, :player_id => 368, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => will_predhomme_league.id, :player_id => 367, :active => false, :league_id => league.id)
    
    chris_bagley = User.create(:first_name => "Chris", :last_name => "Bagley", :email => "bagel0248@gmail.com",
    :password => "password", :password_confirmation => "password")
     
    chris_bagley_league = LeagueMembership.create(:user_id => chris_bagley.id, :league_id => league.id, :name => chris_bagley.name,
    :season_scores => [[["Hyundai", 1], 0.0],
     [["Sony Open", 2], 26.0],
     [["Humana Challenge", 3], 42.5],
     [["Farmers", 4], 7.5],
     [["WM Phoenix Open", 5], 0.0],
     [["Pebble Beach", 6], 123.1],
     [["Northern Trust", 7], 198.0],
     [["Accenture Match Play", 8], 483.0],
     [["Honda", 9], 128.5],
     [["Caddy/PR", 10], 82.75],
     [["Valspar", 11], 177.0],
     [["Arnold Palmer", 12], 16.5],
     [["Valero", 13], 417.0],
     [["Shell Houston", 14], 185.0],
     [["Masters", 15], 291.0],
     [["RBC Heritage", 16], 445.0],
     [["Zurich Classic", 17], 147.0],
     [["Wells Fargo", 18], 235.0],
     [["The Players", 19], 380.5],
     [["HP Byron", 20], 254.0],
     [["Crowne Plaza", 21], 84.13]].to_json)
    DivisionMembership.create(:league_membership_id => chris_bagley_league.id, :division_id => bobby_jones.id)

    RosterMembership.create(:league_membership_id => chris_bagley_league.id, :player_id => 114, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => chris_bagley_league.id, :player_id => 272, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => chris_bagley_league.id, :player_id => 165, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => chris_bagley_league.id, :player_id => 142, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => chris_bagley_league.id, :player_id => 348, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => chris_bagley_league.id, :player_id => 363, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => chris_bagley_league.id, :player_id => 4, :active => false, :league_id => league.id)
    
    jim_brabbins = User.create(:first_name => "Jim", :last_name => "Brabbins", :email => "james.brabbins@gmail.com",
    :password => "password", :password_confirmation => "password")
     
    jim_brabbins_league = LeagueMembership.create(:user_id => jim_brabbins.id, :league_id => league.id, :name => jim_brabbins.name,
    :season_scores => [[["Hyundai", 1], 270.5],
     [["Sony Open", 2], 124.0],
     [["Humana Challenge", 3], 290.2],
     [["Farmers", 4], 96.0],
     [["WM Phoenix Open", 5], 190.6],
     [["Pebble Beach", 6], 88.5],
     [["Northern Trust", 7], 0.0],
     [["Accenture Match Play", 8], 351.5],
     [["Honda", 9], 66.61],
     [["Caddy/PR", 10], 778.5],
     [["Valspar", 11], 94.5],
     [["Arnold Palmer", 12], 72.63],
     [["Valero", 13], 165.0],
     [["Shell Houston", 14], 190.0],
     [["Masters", 15], 310.0],
     [["RBC Heritage", 16], 349.0],
     [["Zurich Classic", 17], 52.77],
     [["Wells Fargo", 18], 192.0],
     [["The Players", 19], 229.5],
     [["HP Byron", 20], 204.5],
     [["Crowne Plaza", 21], 0.0]].to_json)
    DivisionMembership.create(:league_membership_id => jim_brabbins_league.id, :division_id => bobby_jones.id)

    RosterMembership.create(:league_membership_id => jim_brabbins_league.id, :player_id => 194, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => jim_brabbins_league.id, :player_id => 287, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => jim_brabbins_league.id, :player_id => 301, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => jim_brabbins_league.id, :player_id => 156, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => jim_brabbins_league.id, :player_id => 32, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => jim_brabbins_league.id, :player_id => 290, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => jim_brabbins_league.id, :player_id => 337, :active => false, :league_id => league.id)
    
    brian_turner = User.create(:first_name => "Brian", :last_name => "Turner", :email => "bsturner@umich.edu",
    :password => "password", :password_confirmation => "password")
     
    brian_turner_league = LeagueMembership.create(:user_id => brian_turner.id, :league_id => league.id, :name => brian_turner.name,
    :season_scores => [[["Hyundai", 1], 110.0],
     [["Sony Open", 2], 51.0],
     [["Humana Challenge", 3], 107.75],
     [["Farmers", 4], 130.0],
     [["WM Phoenix Open", 5], 180.0],
     [["Pebble Beach", 6], 79.63],
     [["Northern Trust", 7], 91.5],
     [["Accenture Match Play", 8], 103.5],
     [["Honda", 9], 145.0],
     [["Caddy/PR", 10], 242.1],
     [["Valspar", 11], 189.0],
     [["Arnold Palmer", 12], 52.5],
     [["Valero", 13], 172.0],
     [["Shell Houston", 14], 132.0],
     [["Masters", 15], 219.0],
     [["RBC Heritage", 16], 142.17],
     [["Zurich Classic", 17], 268.55],
     [["Wells Fargo", 18], 201.5],
     [["The Players", 19], 200.25],
     [["HP Byron", 20], 156.86],
     [["Crowne Plaza", 21], 221.61]].to_json)
    DivisionMembership.create(:league_membership_id => brian_turner_league.id, :division_id => bobby_jones.id)

    RosterMembership.create(:league_membership_id => brian_turner_league.id, :player_id => 248, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => brian_turner_league.id, :player_id => 256, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => brian_turner_league.id, :player_id => 155, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => brian_turner_league.id, :player_id => 318, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => brian_turner_league.id, :player_id => 145, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => brian_turner_league.id, :player_id => 55, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => brian_turner_league.id, :player_id => 241, :active => false, :league_id => league.id)

    wilson_fraser = User.create(:first_name => "Wilson", :last_name => "Fraser", :email => "fraser.w10@gmail.com",
    :password => "password", :password_confirmation => "password")
     
    wilson_fraser_league = LeagueMembership.create(:user_id => wilson_fraser.id, :league_id => league.id, :name => wilson_fraser.name,
    :season_scores => [[["Hyundai", 1], 135.0],
     [["Sony Open", 2], 0.0],
     [["Humana Challenge", 3], 22.0],
     [["Farmers", 4], 527.5],
     [["WM Phoenix Open", 5], 350.0],
     [["Pebble Beach", 6], 235.6],
     [["Northern Trust", 7], 277.75],
     [["Accenture Match Play", 8], 237.5],
     [["Honda", 9], 38.25],
     [["Caddy/PR", 10], 571.5],
     [["Valspar", 11], 232.0],
     [["Arnold Palmer", 12], 153.0],
     [["Valero", 13], 135.0],
     [["Shell Houston", 14], 116.0],
     [["Masters", 15], 241.0],
     [["RBC Heritage", 16], 0.0],
     [["Zurich Classic", 17], 203.27],
     [["Wells Fargo", 18], 302.13],
     [["The Players", 19], 268.5],
     [["HP Byron", 20], 250.0],
     [["Crowne Plaza", 21], 302.75]].to_json)
    DivisionMembership.create(:league_membership_id => wilson_fraser_league.id, :division_id => moe_norman.id)

    RosterMembership.create(:league_membership_id => wilson_fraser_league.id, :player_id => 401, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => wilson_fraser_league.id, :player_id => 310, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => wilson_fraser_league.id, :player_id => 78, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => wilson_fraser_league.id, :player_id => 56, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => wilson_fraser_league.id, :player_id => 334, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => wilson_fraser_league.id, :player_id => 176, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => wilson_fraser_league.id, :player_id => 186, :active => false, :league_id => league.id)


    mike_desantis = User.create(:first_name => "Mike", :last_name => "DeSantis", :email => "fantasygolfleaguechamp2012@gmail.com",
    :password => "password", :password_confirmation => "password", :admin => true)
     
    mike_desantis_league = LeagueMembership.create(:user_id => mike_desantis.id, :league_id => league.id, :name => mike_desantis.name,
    :season_scores => [[["Hyundai", 1], 69.0],
     [["Sony Open", 2], 11.5],
     [["Humana Challenge", 3], 53.0],
     [["Farmers", 4], 0.0],
     [["WM Phoenix Open", 5], 111.6],
     [["Pebble Beach", 6], 171.29],
     [["Northern Trust", 7], 187.0],
     [["Accenture Match Play", 8], 232.25],
     [["Honda", 9], 54.11],
     [["Caddy/PR", 10], 330.5],
     [["Valspar", 11], 259.0],
     [["Arnold Palmer", 12], 260.63],
     [["Valero", 13], 22.0],
     [["Shell Houston", 14], 0.0],
     [["Masters", 15], 0.0],
     [["RBC Heritage", 16], 73.64],
     [["Zurich Classic", 17], 0.0],
     [["Wells Fargo", 18], 33.5],
     [["The Players", 19], 94.5],
     [["HP Byron", 20], 22.5],
     [["Crowne Plaza", 21], 144.88]].to_json)
    DivisionMembership.create(:league_membership_id => mike_desantis_league.id, :division_id => moe_norman.id)

    RosterMembership.create(:league_membership_id => mike_desantis_league.id, :player_id => 92, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => mike_desantis_league.id, :player_id => 233, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => mike_desantis_league.id, :player_id => 15, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => mike_desantis_league.id, :player_id => 138, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => mike_desantis_league.id, :player_id => 331, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => mike_desantis_league.id, :player_id => 244, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => mike_desantis_league.id, :player_id => 191, :active => false, :league_id => league.id)


    sean_fox = User.create(:first_name => "SeanFox", :last_name => "PatDieters", :email => "shawngfox@gmail.com",
    :password => "password", :password_confirmation => "password")
     
    sean_fox_league = LeagueMembership.create(:user_id => sean_fox.id, :league_id => league.id, :name => sean_fox.name,
    :season_scores => [[["Hyundai", 1], 61.5],
     [["Sony Open", 2], 104.83],
     [["Humana Challenge", 3], 166.5],
     [["Farmers", 4], 53.0],
     [["WM Phoenix Open", 5], 50.5],
     [["Pebble Beach", 6], 34.6],
     [["Northern Trust", 7], 131.5],
     [["Accenture Match Play", 8], 150.0],
     [["Honda", 9], 96.11],
     [["Caddy/PR", 10], 573.0],
     [["Valspar", 11], 104.0],
     [["Arnold Palmer", 12], 66.13],
     [["Valero", 13], 134.5],
     [["Shell Houston", 14], 173.14],
     [["Masters", 15], 697.0],
     [["RBC Heritage", 16], 70.5],
     [["Zurich Classic", 17], 0.0],
     [["Wells Fargo", 18], 27.5],
     [["The Players", 19], 326.25],
     [["HP Byron", 20], 61.5],
     [["Crowne Plaza", 21], 94.11]].to_json)
    DivisionMembership.create(:league_membership_id => sean_fox_league.id, :division_id => moe_norman.id)

    RosterMembership.create(:league_membership_id => sean_fox_league.id, :player_id => 99, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => sean_fox_league.id, :player_id => 129, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => sean_fox_league.id, :player_id => 83, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => sean_fox_league.id, :player_id => 296, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => sean_fox_league.id, :player_id => 268, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => sean_fox_league.id, :player_id => 137, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => sean_fox_league.id, :player_id => 387, :active => false, :league_id => league.id)


    jay_billingsley = User.create(:first_name => "Jay", :last_name => "Billingsly", :email => "billingsley2211@gmail.com",
    :password => "password", :password_confirmation => "password")
     
    jay_billingsley_league = LeagueMembership.create(:user_id => jay_billingsley.id, :league_id => league.id, :name => jay_billingsley.name,
    :season_scores => [[["Hyundai", 1], 329.5],
     [["Sony Open", 2], 144.17],
     [["Humana Challenge", 3], 211.5],
     [["Farmers", 4], 34.5],
     [["WM Phoenix Open", 5], 139.0],
     [["Pebble Beach", 6], 96.0],
     [["Northern Trust", 7], 74.4],
     [["Accenture Match Play", 8], 183.0],
     [["Honda", 9], 360.0],
     [["Caddy/PR", 10], 161.0],
     [["Valspar", 11], 59.0],
     [["Arnold Palmer", 12], 0.0],
     [["Valero", 13], 186.0],
     [["Shell Houston", 14], 266.8],
     [["Masters", 15], 282.0],
     [["RBC Heritage", 16], 246.14],
     [["Zurich Classic", 17], 0.0],
     [["Wells Fargo", 18], 251.63],
     [["The Players", 19], 233.25],
     [["HP Byron", 20], 327.36],
     [["Crowne Plaza", 21], 280.0]].to_json)
    DivisionMembership.create(:league_membership_id => jay_billingsley_league.id, :division_id => moe_norman.id)

    RosterMembership.create(:league_membership_id => jay_billingsley_league.id, :player_id => 242, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => jay_billingsley_league.id, :player_id => 341, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => jay_billingsley_league.id, :player_id => 154, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => jay_billingsley_league.id, :player_id => 277, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => jay_billingsley_league.id, :player_id => 357, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => jay_billingsley_league.id, :player_id => 124, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => jay_billingsley_league.id, :player_id => 42, :active => false, :league_id => league.id)



    andy_pung = User.create(:first_name => "Andy", :last_name => "Pung", :email => "pungandr@gmail.com",
    :password => "password", :password_confirmation => "password")
     
    andy_pung_league = LeagueMembership.create(:user_id => andy_pung.id, :league_id => league.id, :name => andy_pung.name,
    :season_scores => [[["Hyundai", 1], 217.5],
     [["Sony Open", 2], 384.83],
     [["Humana Challenge", 3], 0.0],
     [["Farmers", 4], 340.0],
     [["WM Phoenix Open", 5], 159.7],
     [["Pebble Beach", 6], 67.63],
     [["Northern Trust", 7], 136.0],
     [["Accenture Match Play", 8], 106.5],
     [["Honda", 9], 165.0],
     [["Caddy/PR", 10], 156.0],
     [["Valspar", 11], 45.5],
     [["Arnold Palmer", 12], 45.0],
     [["Valero", 13], 73.5],
     [["Shell Houston", 14], 104.5],
     [["Masters", 15], 357.0],
     [["RBC Heritage", 16], 66.14],
     [["Zurich Classic", 17], 6.0],
     [["Wells Fargo", 18], 99.0],
     [["The Players", 19], 336.75],
     [["HP Byron", 20], 175.0],
     [["Crowne Plaza", 21], 248.43]].to_json)
    DivisionMembership.create(:league_membership_id => andy_pung_league.id, :division_id => moe_norman.id)

    RosterMembership.create(:league_membership_id => andy_pung_league.id, :player_id => 317, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => andy_pung_league.id, :player_id => 205, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => andy_pung_league.id, :player_id => 344, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => andy_pung_league.id, :player_id => 355, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => andy_pung_league.id, :player_id => 57, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => andy_pung_league.id, :player_id => 255, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => andy_pung_league.id, :player_id => 68, :active => false, :league_id => league.id)


    mj_barczak = User.create(:first_name => "MJ", :last_name => "Barczak", :email => "mbarczak22@gmail.com",
    :password => "password", :password_confirmation => "password")
     
    mj_barczak_league = LeagueMembership.create(:user_id => mj_barczak.id, :league_id => league.id, :name => mj_barczak.name,
    :season_scores => [[["Hyundai", 1], 0.0],
     [["Sony Open", 2], 266.0],
     [["Humana Challenge", 3], 246.0],
     [["Farmers", 4], 83.0],
     [["WM Phoenix Open", 5], 428.0],
     [["Pebble Beach", 6], 26.0],
     [["Northern Trust", 7], 59.5],
     [["Accenture Match Play", 8], 103.5],
     [["Honda", 9], 81.61],
     [["Caddy/PR", 10], 194.25],
     [["Valspar", 11], 139.5],
     [["Arnold Palmer", 12], 119.81],
     [["Valero", 13], 89.5],
     [["Shell Houston", 14], 53.0],
     [["Masters", 15], 460.0],
     [["RBC Heritage", 16], 159.67],
     [["Zurich Classic", 17], 35.27],
     [["Wells Fargo", 18], 220.0],
     [["The Players", 19], 64.88],
     [["HP Byron", 20], 220.0],
     [["Crowne Plaza", 21], 104.24]].to_json)
    DivisionMembership.create(:league_membership_id => mj_barczak_league.id, :division_id => horton_smith.id)

    RosterMembership.create(:league_membership_id => mj_barczak_league.id, :player_id => 335, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => mj_barczak_league.id, :player_id => 77, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => mj_barczak_league.id, :player_id => 160, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => mj_barczak_league.id, :player_id => 401, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => mj_barczak_league.id, :player_id => 329, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => mj_barczak_league.id, :player_id => 189, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => mj_barczak_league.id, :player_id => 344, :active => false, :league_id => league.id)
    
    pat_berg = User.create(:first_name => "Pat", :last_name => "Berg", :email => "bergpatr1@gmail.com",
    :password => "password", :password_confirmation => "password")
     
    pat_berg_league = LeagueMembership.create(:user_id => pat_berg.id, :league_id => league.id, :name => pat_berg.name,
    :season_scores => [[["Hyundai", 1], 233.0],
     [["Sony Open", 2], 132.17],
     [["Humana Challenge", 3], 154.5],
     [["Farmers", 4], 17.5],
     [["WM Phoenix Open", 5], 219.5],
     [["Pebble Beach", 6], 67.63],
     [["Northern Trust", 7], 21.25],
     [["Accenture Match Play", 8], 275.25],
     [["Honda", 9], 176.0],
     [["Caddy/PR", 10], 93.0],
     [["Valspar", 11], 160.0],
     [["Arnold Palmer", 12], 197.0],
     [["Valero", 13], 229.0],
     [["Shell Houston", 14], 67.64],
     [["Masters", 15], 148.0],
     [["RBC Heritage", 16], 109.0],
     [["Zurich Classic", 17], 48.0],
     [["Wells Fargo", 18], 91.93],
     [["The Players", 19], 137.25],
     [["HP Byron", 20], 168.0],
     [["Crowne Plaza", 21], 0.0]].to_json)
    DivisionMembership.create(:league_membership_id => pat_berg_league.id, :division_id => horton_smith.id)

    RosterMembership.create(:league_membership_id => pat_berg_league.id, :player_id => 321, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => pat_berg_league.id, :player_id => 341, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => pat_berg_league.id, :player_id => 383, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => pat_berg_league.id, :player_id => 269, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => pat_berg_league.id, :player_id => 222, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => pat_berg_league.id, :player_id => 192, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => pat_berg_league.id, :player_id => 223, :active => false, :league_id => league.id)
    
    
    chris_cunningham = User.create(:first_name => "Chris", :last_name => "Cunningham", :email => "cunnichr@mail.gvsu.edu",
    :password => "password", :password_confirmation => "password")
     
    chris_cunningham_league = LeagueMembership.create(:user_id => chris_cunningham.id, :league_id => league.id, :name => chris_cunningham.name,
    :season_scores => [[["Hyundai", 1], 260.5],
     [["Sony Open", 2], 360.0],
     [["Humana Challenge", 3], 93.2],
     [["Farmers", 4], 0.0],
     [["WM Phoenix Open", 5], 144.0],
     [["Pebble Beach", 6], 32.0],
     [["Northern Trust", 7], 193.0],
     [["Accenture Match Play", 8], 305.25],
     [["Honda", 9], 6.5],
     [["Caddy/PR", 10], 92.44],
     [["Valspar", 11], 85.5],
     [["Arnold Palmer", 12], 101.75],
     [["Valero", 13], 54.0],
     [["Shell Houston", 14], 34.5],
     [["Masters", 15], 710.0],
     [["RBC Heritage", 16], 24.0],
     [["Zurich Classic", 17], 244.5],
     [["Wells Fargo", 18], 120.0],
     [["The Players", 19], 31.5],
     [["HP Byron", 20], 44.0],
     [["Crowne Plaza", 21], 225.5]].to_json)
    DivisionMembership.create(:league_membership_id => chris_cunningham_league.id, :division_id => horton_smith.id)

    RosterMembership.create(:league_membership_id => chris_cunningham_league.id, :player_id => 86, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => chris_cunningham_league.id, :player_id => 52, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => chris_cunningham_league.id, :player_id => 370, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => chris_cunningham_league.id, :player_id => 274, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => chris_cunningham_league.id, :player_id => 30, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => chris_cunningham_league.id, :player_id => 264, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => chris_cunningham_league.id, :player_id => 178, :active => false, :league_id => league.id)
    
    bobby_urso = User.create(:first_name => "Bobby", :last_name => "Urso", :email => "bfurso@gmail.com",
    :password => "password", :password_confirmation => "password")
     
    bobby_urso_league = LeagueMembership.create(:user_id => bobby_urso.id, :league_id => league.id, :name => bobby_urso.name,
    :season_scores => [[["Hyundai", 1], 190.0],
     [["Sony Open", 2], 0.0],
     [["Humana Challenge", 3], 0.0],
     [["Farmers", 4], 73.5],
     [["WM Phoenix Open", 5], 0.0],
     [["Pebble Beach", 6], 191.0],
     [["Northern Trust", 7], 45.75],
     [["Accenture Match Play", 8], 135.0],
     [["Honda", 9], 198.0],
     [["Caddy/PR", 10], 206.25],
     [["Valspar", 11], 229.0],
     [["Arnold Palmer", 12], 11.5],
     [["Valero", 13], 9.0],
     [["Shell Houston", 14], 56.14],
     [["Masters", 15], 138.0],
     [["RBC Heritage", 16], 265.0],
     [["Zurich Classic", 17], 97.5],
     [["Wells Fargo", 18], 0.0],
     [["The Players", 19], 59.25],
     [["HP Byron", 20], 83.5],
     [["Crowne Plaza", 21], 0.0]].to_json)
    DivisionMembership.create(:league_membership_id => bobby_urso_league.id, :division_id => horton_smith.id)

    RosterMembership.create(:league_membership_id => bobby_urso_league.id, :player_id => 290, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => bobby_urso_league.id, :player_id => 82, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => bobby_urso_league.id, :player_id => 66, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => bobby_urso_league.id, :player_id => 402, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => bobby_urso_league.id, :player_id => 135, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => bobby_urso_league.id, :player_id => 51, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => bobby_urso_league.id, :player_id => 132, :active => false, :league_id => league.id)
    
    
    trent_busch = User.create(:first_name => "Trent", :last_name => "Busch", :email => "trenton.busch@flextronics.com",
    :password => "password", :password_confirmation => "password")
     
    trent_busch_league = LeagueMembership.create(:user_id => trent_busch.id, :league_id => league.id, :name => trent_busch.name,
    :season_scores => [[["Hyundai", 1], 75.0],
     [["Sony Open", 2], 0.0],
     [["Humana Challenge", 3], 26.5],
     [["Farmers", 4], 95.1],
     [["WM Phoenix Open", 5], 84.1],
     [["Pebble Beach", 6], 52.0],
     [["Northern Trust", 7], 227.0],
     [["Accenture Match Play", 8], 284.75],
     [["Honda", 9], 106.5],
     [["Caddy/PR", 10], 269.63],
     [["Valspar", 11], 269.5],
     [["Arnold Palmer", 12], 0.0],
     [["Valero", 13], 0.0],
     [["Shell Houston", 14], 83.5],
     [["Masters", 15], 219.0],
     [["RBC Heritage", 16], 123.0],
     [["Zurich Classic", 17], 150.0],
     [["Wells Fargo", 18], 43.13],
     [["The Players", 19], 31.5],
     [["HP Byron", 20], 141.0],
     [["Crowne Plaza", 21], 104.24]].to_json)
    DivisionMembership.create(:league_membership_id => trent_busch_league.id, :division_id => horton_smith.id)

    RosterMembership.create(:league_membership_id => trent_busch_league.id, :player_id => 315, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => trent_busch_league.id, :player_id => 197, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => trent_busch_league.id, :player_id => 121, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => trent_busch_league.id, :player_id => 182, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => trent_busch_league.id, :player_id => 27, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => trent_busch_league.id, :player_id => 228, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => trent_busch_league.id, :player_id => 60, :active => false, :league_id => league.id)    
  end
  
  desc "Seed demo league"
  task demo_seed: :environment do
    league = League.create(:name => "The Caddy Shack")
    
    ben_hogan = Division.create(:name => "Ben Hogan", :league_id => league.id)
    arnold_palmer = Division.create(:name => "Arnold Palmer", :league_id => league.id)
    
    guest = User.create(:first_name => "Guesty", :last_name => "MyGuesterson", :email => "guest@gmail.com",
    :password => "password", :password_confirmation => "password")
    guest_league = LeagueMembership.create(:user_id => guest.id, :league_id => league.id, :name => guest.name,
    :season_scores => [[["Hyundai", 1], 303.0],
     [["Sony Open", 2], 97.5],
     [["Humana Challenge", 3], 336.7],
     [["Farmers", 4], 23.5],
     [["WM Phoenix Open", 5], 89.0],
     [["Pebble Beach", 6], 88.5],
     [["Northern Trust", 7], 154.0],
     [["Accenture Match Play", 8], 111.0],
     [["Honda", 9], 92.36],
     [["Caddy/PR", 10], 275.25],
     [["Valspar", 11], 150.67],
     [["Arnold Palmer", 12], 304.0],
     [["Valero", 13], 158.5],
     [["Shell Houston", 14], 26.0],
     [["Masters", 15], 308.0],
     [["RBC Heritage", 16], 165.25],
     [["Zurich Classic", 17], 0.0],
     [["Wells Fargo", 18], 218.63],
     [["The Players", 19], 498.75],
     [["HP Byron", 20], 71.0],
     [["Crowne Plaza", 21], 84.0]].to_json
    )
    DivisionMembership.create(:league_membership_id => guest_league.id, :division_id => ben_hogan.id)

    RosterMembership.create(:league_membership_id => guest_league.id, :player_id => 180, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => guest_league.id, :player_id => 185, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => guest_league.id, :player_id => 44, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => guest_league.id, :player_id => 96, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => guest_league.id, :player_id => 74, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => guest_league.id, :player_id => 220, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => guest_league.id, :player_id => 35, :active => false, :league_id => league.id)
    
    
    chevy_chase = User.create(:first_name => "Chevy", :last_name => "Chase", :email => "chevy@gmail.com",
    :password => "password", :password_confirmation => "password")
    chevy_chase_league = LeagueMembership.create(:user_id => chevy_chase.id, :league_id => league.id, :name => chevy_chase.name,
    :season_scores => [[["Hyundai", 1], 75.0],
     [["Sony Open", 2], 0.0],
     [["Humana Challenge", 3], 26.5],
     [["Farmers", 4], 95.1],
     [["WM Phoenix Open", 5], 84.1],
     [["Pebble Beach", 6], 52.0],
     [["Northern Trust", 7], 227.0],
     [["Accenture Match Play", 8], 284.75],
     [["Honda", 9], 106.5],
     [["Caddy/PR", 10], 269.63],
     [["Valspar", 11], 269.5],
     [["Arnold Palmer", 12], 0.0],
     [["Valero", 13], 0.0],
     [["Shell Houston", 14], 83.5],
     [["Masters", 15], 219.0],
     [["RBC Heritage", 16], 123.0],
     [["Zurich Classic", 17], 150.0],
     [["Wells Fargo", 18], 43.13],
     [["The Players", 19], 31.5],
     [["HP Byron", 20], 141.0],
     [["Crowne Plaza", 21], 104.24]].to_json)
    DivisionMembership.create(:league_membership_id => chevy_chase_league.id, :division_id => ben_hogan.id)

    RosterMembership.create(:league_membership_id => chevy_chase_league.id, :player_id => 36, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => chevy_chase_league.id, :player_id => 380, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => chevy_chase_league.id, :player_id => 188, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => chevy_chase_league.id, :player_id => 85, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => chevy_chase_league.id, :player_id => 181, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => chevy_chase_league.id, :player_id => 59, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => chevy_chase_league.id, :player_id => 170, :active => false, :league_id => league.id)
    
    
    bill_murray = User.create(:first_name => "Bill", :last_name => "Murray", :email => "bill@gmail.com",
    :password => "password", :password_confirmation => "password")
    bill_murray_league = LeagueMembership.create(:user_id => bill_murray.id, :league_id => league.id, :name => bill_murray.name,
    :season_scores => [[["Hyundai", 1], 260.5],
     [["Sony Open", 2], 360.0],
     [["Humana Challenge", 3], 93.2],
     [["Farmers", 4], 0.0],
     [["WM Phoenix Open", 5], 144.0],
     [["Pebble Beach", 6], 32.0],
     [["Northern Trust", 7], 193.0],
     [["Accenture Match Play", 8], 305.25],
     [["Honda", 9], 6.5],
     [["Caddy/PR", 10], 92.44],
     [["Valspar", 11], 85.5],
     [["Arnold Palmer", 12], 101.75],
     [["Valero", 13], 54.0],
     [["Shell Houston", 14], 34.5],
     [["Masters", 15], 710.0],
     [["RBC Heritage", 16], 24.0],
     [["Zurich Classic", 17], 244.5],
     [["Wells Fargo", 18], 120.0],
     [["The Players", 19], 31.5],
     [["HP Byron", 20], 44.0],
     [["Crowne Plaza", 21], 225.5]].to_json)
    DivisionMembership.create(:league_membership_id => bill_murray_league.id, :division_id => ben_hogan.id)

    RosterMembership.create(:league_membership_id => bill_murray_league.id, :player_id => 239, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => bill_murray_league.id, :player_id => 106, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => bill_murray_league.id, :player_id => 382, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => bill_murray_league.id, :player_id => 141, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => bill_murray_league.id, :player_id => 174, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => bill_murray_league.id, :player_id => 115, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => bill_murray_league.id, :player_id => 320, :active => false, :league_id => league.id)    

    rodney_dangerfield = User.create(:first_name => "Rodney", :last_name => "Dangerfield", :email => "rodney@gmail.com",
    :password => "password", :password_confirmation => "password")
    rodney_dangerfield_league = LeagueMembership.create(:user_id => rodney_dangerfield.id, :league_id => league.id, :name => rodney_dangerfield.name,
    :season_scores => [[["Hyundai", 1], 233.0],
     [["Sony Open", 2], 132.17],
     [["Humana Challenge", 3], 154.5],
     [["Farmers", 4], 17.5],
     [["WM Phoenix Open", 5], 219.5],
     [["Pebble Beach", 6], 67.63],
     [["Northern Trust", 7], 21.25],
     [["Accenture Match Play", 8], 275.25],
     [["Honda", 9], 176.0],
     [["Caddy/PR", 10], 93.0],
     [["Valspar", 11], 160.0],
     [["Arnold Palmer", 12], 197.0],
     [["Valero", 13], 229.0],
     [["Shell Houston", 14], 67.64],
     [["Masters", 15], 148.0],
     [["RBC Heritage", 16], 109.0],
     [["Zurich Classic", 17], 48.0],
     [["Wells Fargo", 18], 91.93],
     [["The Players", 19], 137.25],
     [["HP Byron", 20], 168.0],
     [["Crowne Plaza", 21], 0.0]].to_json)
    DivisionMembership.create(:league_membership_id => rodney_dangerfield_league.id, :division_id => ben_hogan.id)

    RosterMembership.create(:league_membership_id => rodney_dangerfield_league.id, :player_id => 226, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => rodney_dangerfield_league.id, :player_id => 396, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => rodney_dangerfield_league.id, :player_id => 159, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => rodney_dangerfield_league.id, :player_id => 171, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => rodney_dangerfield_league.id, :player_id => 264, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => rodney_dangerfield_league.id, :player_id => 206, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => rodney_dangerfield_league.id, :player_id => 377, :active => false, :league_id => league.id)
    
    
    cindy_morgan = User.create(:first_name => "Cindy", :last_name => "Morgan", :email => "cindy@gmail.com",
    :password => "password", :password_confirmation => "password")
    cindy_morgan_league = LeagueMembership.create(:user_id => cindy_morgan.id, :league_id => league.id, :name => cindy_morgan.name,
    :season_scores => [[["Hyundai", 1], 217.5],
         [["Sony Open", 2], 384.83],
         [["Humana Challenge", 3], 0.0],
         [["Farmers", 4], 340.0],
         [["WM Phoenix Open", 5], 159.7],
         [["Pebble Beach", 6], 67.63],
         [["Northern Trust", 7], 136.0],
         [["Accenture Match Play", 8], 106.5],
         [["Honda", 9], 165.0],
         [["Caddy/PR", 10], 156.0],
         [["Valspar", 11], 45.5],
         [["Arnold Palmer", 12], 45.0],
         [["Valero", 13], 73.5],
         [["Shell Houston", 14], 104.5],
         [["Masters", 15], 357.0],
         [["RBC Heritage", 16], 66.14],
         [["Zurich Classic", 17], 6.0],
         [["Wells Fargo", 18], 99.0],
         [["The Players", 19], 336.75],
         [["HP Byron", 20], 175.0],
         [["Crowne Plaza", 21], 248.43]].to_json)
    DivisionMembership.create(:league_membership_id => cindy_morgan_league.id, :division_id => ben_hogan.id)

    RosterMembership.create(:league_membership_id => cindy_morgan_league.id, :player_id => 327, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => cindy_morgan_league.id, :player_id => 381, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => cindy_morgan_league.id, :player_id => 149, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => cindy_morgan_league.id, :player_id => 16, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => cindy_morgan_league.id, :player_id => 212, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => cindy_morgan_league.id, :player_id => 157, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => cindy_morgan_league.id, :player_id => 116, :active => false, :league_id => league.id)
    
    
    ty_webb = User.create(:first_name => "Ty", :last_name => "Webb", :email => "ty@gmail.com",
    :password => "password", :password_confirmation => "password")
    ty_webb_league = LeagueMembership.create(:user_id => ty_webb.id, :league_id => league.id, :name => ty_webb.name,
    :season_scores => [[["Hyundai", 1], 207.5],
         [["Sony Open", 2], 304.83],
         [["Humana Challenge", 3], 0.0],
         [["Farmers", 4], 340.0],
         [["WM Phoenix Open", 5], 159.7],
         [["Pebble Beach", 6], 45.63],
         [["Northern Trust", 7], 136.0],
         [["Accenture Match Play", 8], 16.5],
         [["Honda", 9], 165.0],
         [["Caddy/PR", 10], 156.0],
         [["Valspar", 11], 45.5],
         [["Arnold Palmer", 12], 45.0],
         [["Valero", 13], 73.5],
         [["Shell Houston", 14], 104.5],
         [["Masters", 15], 357.0],
         [["RBC Heritage", 16], 6.14],
         [["Zurich Classic", 17], 60.0],
         [["Wells Fargo", 18], 99.0],
         [["The Players", 19], 336.75],
         [["HP Byron", 20], 175.0],
         [["Crowne Plaza", 21], 248.43]].to_json)
    DivisionMembership.create(:league_membership_id => ty_webb_league.id, :division_id => arnold_palmer.id)

    RosterMembership.create(:league_membership_id => ty_webb_league.id, :player_id => 401, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => ty_webb_league.id, :player_id => 310, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => ty_webb_league.id, :player_id => 78, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => ty_webb_league.id, :player_id => 56, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => ty_webb_league.id, :player_id => 334, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => ty_webb_league.id, :player_id => 176, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => ty_webb_league.id, :player_id => 186, :active => false, :league_id => league.id)


    judge_smails = User.create(:first_name => "Judge", :last_name => "Smails", :email => "judgesmails@gmail.com",
    :password => "password", :password_confirmation => "password")
    judge_smails_league = LeagueMembership.create(:user_id => judge_smails.id, :league_id => league.id, :name => judge_smails.name,
    :season_scores => [[["Hyundai", 1], 0.0],
     [["Sony Open", 2], 266.0],
     [["Humana Challenge", 3], 246.0],
     [["Farmers", 4], 83.0],
     [["WM Phoenix Open", 5], 428.0],
     [["Pebble Beach", 6], 26.0],
     [["Northern Trust", 7], 59.5],
     [["Accenture Match Play", 8], 103.5],
     [["Honda", 9], 81.61],
     [["Caddy/PR", 10], 194.25],
     [["Valspar", 11], 139.5],
     [["Arnold Palmer", 12], 119.81],
     [["Valero", 13], 89.5],
     [["Shell Houston", 14], 53.0],
     [["Masters", 15], 460.0],
     [["RBC Heritage", 16], 159.67],
     [["Zurich Classic", 17], 35.27],
     [["Wells Fargo", 18], 220.0],
     [["The Players", 19], 64.88],
     [["HP Byron", 20], 220.0],
     [["Crowne Plaza", 21], 104.24]].to_json)
    DivisionMembership.create(:league_membership_id => judge_smails_league.id, :division_id => arnold_palmer.id)

    RosterMembership.create(:league_membership_id => judge_smails_league.id, :player_id => 92, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => judge_smails_league.id, :player_id => 233, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => judge_smails_league.id, :player_id => 15, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => judge_smails_league.id, :player_id => 138, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => judge_smails_league.id, :player_id => 331, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => judge_smails_league.id, :player_id => 244, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => judge_smails_league.id, :player_id => 191, :active => false, :league_id => league.id)


    danny_noonan = User.create(:first_name => "Danny", :last_name => "Noonan", :email => "danny@gmail.com",
    :password => "password", :password_confirmation => "password")
    danny_noonan_league = LeagueMembership.create(:user_id => danny_noonan.id, :league_id => league.id, :name => danny_noonan.name,
    :season_scores => [[["Hyundai", 1], 135.0],
     [["Sony Open", 2], 0.0],
     [["Humana Challenge", 3], 22.0],
     [["Farmers", 4], 527.5],
     [["WM Phoenix Open", 5], 350.0],
     [["Pebble Beach", 6], 235.6],
     [["Northern Trust", 7], 277.75],
     [["Accenture Match Play", 8], 237.5],
     [["Honda", 9], 38.25],
     [["Caddy/PR", 10], 571.5],
     [["Valspar", 11], 232.0],
     [["Arnold Palmer", 12], 153.0],
     [["Valero", 13], 135.0],
     [["Shell Houston", 14], 116.0],
     [["Masters", 15], 241.0],
     [["RBC Heritage", 16], 0.0],
     [["Zurich Classic", 17], 203.27],
     [["Wells Fargo", 18], 302.13],
     [["The Players", 19], 268.5],
     [["HP Byron", 20], 250.0],
     [["Crowne Plaza", 21], 302.75]].to_json)
    DivisionMembership.create(:league_membership_id => danny_noonan_league.id, :division_id => arnold_palmer.id)

    RosterMembership.create(:league_membership_id => danny_noonan_league.id, :player_id => 99, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => danny_noonan_league.id, :player_id => 129, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => danny_noonan_league.id, :player_id => 83, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => danny_noonan_league.id, :player_id => 296, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => danny_noonan_league.id, :player_id => 268, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => danny_noonan_league.id, :player_id => 137, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => danny_noonan_league.id, :player_id => 387, :active => false, :league_id => league.id)


    bishop_pickering = User.create(:first_name => "Bishop", :last_name => "Pickering", :email => "bishop@gmail.com",
    :password => "password", :password_confirmation => "password")
    bishop_pickering_league = LeagueMembership.create(:user_id => bishop_pickering.id, :league_id => league.id, :name => bishop_pickering.name,
    :season_scores => [[["Hyundai", 1], 228.0],
     [["Sony Open", 2], 11.5],
     [["Humana Challenge", 3], 169.0],
     [["Farmers", 4], 312.43],
     [["WM Phoenix Open", 5], 200.0],
     [["Pebble Beach", 6], 217.63],
     [["Northern Trust", 7], 38.0],
     [["Accenture Match Play", 8], 363.5],
     [["Honda", 9], 0.0],
     [["Caddy/PR", 10], 326.63],
     [["Valspar", 11], 182.0],
     [["Arnold Palmer", 12], 219.5],
     [["Valero", 13], 73.5],
     [["Shell Houston", 14], 96.0],
     [["Masters", 15], 286.0],
     [["RBC Heritage", 16], 79.0],
     [["Zurich Classic", 17], 250.0],
     [["Wells Fargo", 18], 97.0],
     [["The Players", 19], 228.25],
     [["HP Byron", 20], 125.0],
     [["Crowne Plaza", 21], 29.0]].to_json)
    DivisionMembership.create(:league_membership_id => bishop_pickering_league.id, :division_id => arnold_palmer.id)

    RosterMembership.create(:league_membership_id => bishop_pickering_league.id, :player_id => 242, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => bishop_pickering_league.id, :player_id => 341, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => bishop_pickering_league.id, :player_id => 154, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => bishop_pickering_league.id, :player_id => 277, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => bishop_pickering_league.id, :player_id => 357, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => bishop_pickering_league.id, :player_id => 124, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => bishop_pickering_league.id, :player_id => 42, :active => false, :league_id => league.id)



    carl_spacker = User.create(:first_name => "Carl", :last_name => "Spacker", :email => "carl@gmail.com",
    :password => "password", :password_confirmation => "password")
    carl_spacker_league = LeagueMembership.create(:user_id => carl_spacker.id, :league_id => league.id, :name => carl_spacker.name,
    :season_scores => [[["Hyundai", 1], 0.0],
     [["Sony Open", 2], 26.0],
     [["Humana Challenge", 3], 42.5],
     [["Farmers", 4], 7.5],
     [["WM Phoenix Open", 5], 0.0],
     [["Pebble Beach", 6], 123.1],
     [["Northern Trust", 7], 198.0],
     [["Accenture Match Play", 8], 483.0],
     [["Honda", 9], 128.5],
     [["Caddy/PR", 10], 82.75],
     [["Valspar", 11], 177.0],
     [["Arnold Palmer", 12], 16.5],
     [["Valero", 13], 417.0],
     [["Shell Houston", 14], 185.0],
     [["Masters", 15], 291.0],
     [["RBC Heritage", 16], 445.0],
     [["Zurich Classic", 17], 147.0],
     [["Wells Fargo", 18], 235.0],
     [["The Players", 19], 380.5],
     [["HP Byron", 20], 254.0],
     [["Crowne Plaza", 21], 84.13]].to_json)
    DivisionMembership.create(:league_membership_id => carl_spacker_league.id, :division_id => arnold_palmer.id)

    RosterMembership.create(:league_membership_id => carl_spacker_league.id, :player_id => 317, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => carl_spacker_league.id, :player_id => 205, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => carl_spacker_league.id, :player_id => 344, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => carl_spacker_league.id, :player_id => 355, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => carl_spacker_league.id, :player_id => 57, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => carl_spacker_league.id, :player_id => 255, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => carl_spacker_league.id, :player_id => 68, :active => false, :league_id => league.id)

    LeagueMembership.each do |lm|
      arr = JSON.parse(lm.season_scores)
      arr.each do |entry|
        Week.where("entry")
      end
    end
  end
  
  desc "Add zero scores for tournaments"
  task add_zero_scores: :environment do
    weeks = Week.where("week_order > ?", 21)
    weeks.each do |week|
      tournament = week.tournaments.first
      LeagueMembership.all.each do |lm|
        arr = JSON.parse(lm.season_scores)
        p "Adding #{[[tournament.name, week.week_order], 0.0]}"
        arr.push([[tournament.name, week.week_order], 0.0])
        lm.season_scores = arr.to_json
        lm.save
      end if tournament
    end
  end

  desc "Score all tournaments"
  task pull_all_tournament_scores: :environment do
    Tournament.all.each{|t| t.get_scores}
  end

  desc "Update player score from array"
  task update_lm_scores: :environment do
    LeagueMembership.all.each do |lm| 
      puts "Updating #{lm.name}"
      pts = lm.calculate_season_points_from_season_scores
      lm.season_points = pts
      lm.save
    end
    puts "Done."
  end

  desc "Reset all data except for players"
  task reset_user_data: :environment do
    League.delete_all
    LeagueMembership.delete_all
    RosterMembership.delete_all
    Division.delete_all
    DivisionMembership.delete_all
    ArchivedWeek.delete_all
    FreeAgentOffer.delete_all
    Trade.delete_all
    Season.delete_all
    TradeGroup.delete_all
    TradeGroupMembership.delete_all
    Tournament.delete_all
    TournamentStanding.delete_all
    User.delete_all
    Week.delete_all
  end

end
