# == Schema Information
#
# Table name: tournaments
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  start_date :datetime
#  end_date   :datetime
#  url        :string(255)
#  created_at :datetime
#  updated_at :datetime
#  complete   :boolean
#  week_id    :integer
#  multiplier :float
#

class Tournament < ActiveRecord::Base 

  FANTASY_POINTS = [250,190,180,170,160,150,140,130,
    120,110,102,99,96,93,90,87,84,81,
    78,75,72,69,66,63,60,58,56,54,52,
    50,48,46,44,42,40,38,37,36,35,34,
    33,32,31,30,29,28,27,26,25,24,23,
    22,21,20,19,18,17,16,15,14,13,12,
    11,10,9,8,7,6,5,4,3,2].freeze

    has_many :tournament_standings, :dependent => :destroy
    has_many :players, :through => :tournament_standings
    belongs_to :week
    validates :name, :uniqueness => true
    validates :week_id, :name, :presence => true
  
    def get_scores
      puts '####################################################'
      puts '####################################################'
      puts "Scoring: #{self.name}"
      puts '####################################################'
      puts '####################################################'
      page = Nokogiri::HTML(RestClient.get(self.url))

      players = page.xpath('//table/tbody/tr/td/a')
      leaderboard = []
    
      players.each do |player|
        entry = {}
        td = player.parent().parent()
        puts "position"
        puts "#{td.css(".position").text.gsub("\n", "")}"
        entry["position"] = td.css(".position").text.gsub("\n", "")

        int = entry["position"].match(/\A\D*(\d+)\z/)

        if int
          entry["int_position"] = int[1].to_i
        else
          next
        end

        entry["player_id"] = player.attributes["href"].value.match(/\A\D+(\d+).+\z/)[1].to_i
        entry["to_par"] = td.css(".total").text.gsub("\n", "")
        entry["winnings"] = td.css(".earnings")
        .text.gsub("$", "")
        .gsub("\n", "")
        .gsub("-", "0")
        .gsub(",", "")
        .to_i
        leaderboard << entry
      end
      self.tournament_standings.create!(calculate_fantasy_scores(leaderboard))
    end
  
    def calculate_fantasy_scores(leaderboard)
      fantasy_points = FANTASY_POINTS.dup
      int_scores = leaderboard.sort_by{|entry| entry["winnings"]}.reverse.map{|entry| entry["int_position"]}
      i = 0
      until fantasy_points.empty? || i == leaderboard.length do
        position_occurrences = int_scores.count(leaderboard[i]["int_position"])
        if position_occurrences == 1
          leaderboard[i]["fantasy_points"] = fantasy_points.shift
          i += 1
        else
          scores = fantasy_points.shift(position_occurrences)
          if scores.empty?
            fantasy_pts = 0
          else
            fantasy_pts = scores.inject(0){|sum, add| sum + add}.to_f / scores.length
          end
          position_occurrences.times do |j|
            leaderboard[i+j]["fantasy_points"] = fantasy_pts
          end
          i += position_occurrences
        end
      end
    
      leaderboard
    end    
  end
