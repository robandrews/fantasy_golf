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
    steve_doman_league = LeagueMembership.create(:user_id => steve_doman.id, :league_id => league.id, :name => steve_doman.name)
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
    jake_oconner_league = LeagueMembership.create(:user_id => jake_oconner.id, :league_id => league.id, :name => jake_oconner.name)
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
    robert_acho_league = LeagueMembership.create(:user_id => robert_acho.id, :league_id => league.id, :name => robert_acho.name)
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
    matt_alessi_league = LeagueMembership.create(:user_id => matt_alessi.id, :league_id => league.id, :name => matt_alessi.name)
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
    morgan_priestley_league = LeagueMembership.create(:user_id => morgan_priestley.id, :league_id => league.id, :name => morgan_priestley.name)
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
    brian_lepine_league = LeagueMembership.create(:user_id => brian_lepine.id, :league_id => league.id, :name => brian_lepine.name)
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
    will_predhomme_league = LeagueMembership.create(:user_id => will_predhomme.id, :league_id => league.id, :name => will_predhomme.name)
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
    chris_bagley_league = LeagueMembership.create(:user_id => chris_bagley.id, :league_id => league.id, :name => chris_bagley.name)
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
    jim_brabbins_league = LeagueMembership.create(:user_id => jim_brabbins.id, :league_id => league.id, :name => jim_brabbins.name)
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
    brian_turner_league = LeagueMembership.create(:user_id => brian_turner.id, :league_id => league.id, :name => brian_turner.name)
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
    wilson_fraser_league = LeagueMembership.create(:user_id => wilson_fraser.id, :league_id => league.id, :name => wilson_fraser.name)
    DivisionMembership.create(:league_membership_id => wilson_fraser_league.id, :division_id => moe_norman.id)

    RosterMembership.create(:league_membership_id => wilson_fraser_league.id, :player_id => 401, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => wilson_fraser_league.id, :player_id => 310, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => wilson_fraser_league.id, :player_id => 78, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => wilson_fraser_league.id, :player_id => 56, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => wilson_fraser_league.id, :player_id => 334, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => wilson_fraser_league.id, :player_id => 176, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => wilson_fraser_league.id, :player_id => 186, :active => false, :league_id => league.id)


    mike_desantis = User.create(:first_name => "Mike", :last_name => "DeSantis", :email => "fantasygolfleaguechamp2012@gmail.com",
    :password => "password", :password_confirmation => "password")
    mike_desantis_league = LeagueMembership.create(:user_id => mike_desantis.id, :league_id => league.id, :name => mike_desantis.name)
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
    sean_fox_league = LeagueMembership.create(:user_id => sean_fox.id, :league_id => league.id, :name => sean_fox.name)
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
    jay_billingsley_league = LeagueMembership.create(:user_id => jay_billingsley.id, :league_id => league.id, :name => jay_billingsley.name)
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
    andy_pung_league = LeagueMembership.create(:user_id => andy_pung.id, :league_id => league.id, :name => andy_pung.name)
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
    mj_barczak_league = LeagueMembership.create(:user_id => mj_barczak.id, :league_id => league.id, :name => mj_barczak.name)
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
    pat_berg_league = LeagueMembership.create(:user_id => pat_berg.id, :league_id => league.id, :name => pat_berg.name)
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
    chris_cunningham_league = LeagueMembership.create(:user_id => chris_cunningham.id, :league_id => league.id, :name => chris_cunningham.name)
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
    bobby_urso_league = LeagueMembership.create(:user_id => bobby_urso.id, :league_id => league.id, :name => bobby_urso.name)
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
    trent_busch_league = LeagueMembership.create(:user_id => trent_busch.id, :league_id => league.id, :name => trent_busch.name)
    DivisionMembership.create(:league_membership_id => trent_busch_league.id, :division_id => horton_smith.id)

    RosterMembership.create(:league_membership_id => trent_busch_league.id, :player_id => 315, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => trent_busch_league.id, :player_id => 197, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => trent_busch_league.id, :player_id => 121, :active => true, :league_id => league.id)
    RosterMembership.create(:league_membership_id => trent_busch_league.id, :player_id => 182, :active => true, :league_id => league.id)
    
    RosterMembership.create(:league_membership_id => trent_busch_league.id, :player_id => 27, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => trent_busch_league.id, :player_id => 228, :active => false, :league_id => league.id)
    RosterMembership.create(:league_membership_id => trent_busch_league.id, :player_id => 60, :active => false, :league_id => league.id)
    
    
  end
end
