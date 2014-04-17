# == Schema Information
#
# Table name: tournaments
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  start_date :date
#  end_date   :date
#  url        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Tournament < ActiveRecord::Base 
  has_many :tournament_standings, :dependent => :destroy
  has_many :players, :through => :tournament_standings
  
  validates :start_date, :end_date, :name, :uniqueness => true
  
  def get_scores
    page = Nokogiri::HTML(RestClient.get(self.url))

    players = page.xpath('//table/tbody/tr/td/a')
    leaderboard = []
    players.each do |player|
      entry = {}
      td = player.parent().parent()
      entry["position"] = td.css(".position").text.gsub("\n", "")
      entry["player_id"] = player.attributes["href"].value.match(/\A\D+(\d+).+\z/)[1].to_i
      entry["to_par"] = td.css(".total").text.gsub("\n", "")
      entry["winnings"] = td.css(".earnings")
                                .text.gsub("$", "")
                                .gsub("\n", "")
                                .gsub("-", "0")
                                .gsub(",", "")
                                .to_i
      leaderboard << entry
      # leaderboard.reject!{|entry| entry["player_id"].empty?}
      # p leaderboard
    end
    
    self.tournament_standings.create!(leaderboard)
  end
end
