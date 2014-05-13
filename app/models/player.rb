# == Schema Information
#
# Table name: players
#
#  id              :integer          not null, primary key
#  first_name      :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  url             :string(255)
#  picture_url     :string(255)
#  birthdate       :date
#  weight          :integer
#  height          :integer
#  last_name       :string(255)
#  birth_place     :string(255)
#  college         :string(255)
#  career_earnings :integer
#  playable        :boolean          default(TRUE)
#  yahoo_id        :integer
#

class Player < ActiveRecord::Base
  has_many :tournament_standings,
  :class_name => "TournamentStanding",
  :foreign_key => :yahoo_id,
  :primary_key => :yahoo_id
  
  has_many :roster_memberships
  has_many :free_agent_offers
  
  validates :yahoo_id, :uniqueness => true
  validates :url, :first_name, :last_name, :presence => true
  
  def string_height
    if self.height
      ft, inches = self.height.divmod(12)
      "#{ft} ft, #{inches} in"
    end
  end
  
  def name
    [self.first_name, self.last_name].join(" ")
  end

  
  def self.construct_from_url(url)
    attrs = {}
    attrs["url"] = url
    attrs["yahoo_id"] = url.match(/\A\D+(\d+)\z/)[1].to_i
    page = Nokogiri::HTML(RestClient.get(url))
    attrs["picture_url"] = page.css("div.playerPhoto").css("img").attr("src").value
    stats = page.css("div.playerStats").css("li")
    stats.each do |stat|
      if stat.css("em").text == "Height:"
        height = stat.css("span").text.split("-")
        attrs["height"] = height[0].to_i*12 + height[1].to_i
      elsif stat.css("em").text == "Weight:"
        attrs["weight"] = stat.css("span").text.to_i
      elsif stat.css("em").text == "Name:"
        attrs["first_name"], attrs["last_name"] = stat.css("span").text.split(" ")
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
