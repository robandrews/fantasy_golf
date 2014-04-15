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


require 'open-uri'
start = Time.now
t = Tournament.create!(:name=>"Hyundai Tournament of Champions",
                      :url => "https://sports.yahoo.com/golf/pga/leaderboard/2014/1",
                      :start_date => Date.new(2014, 1, 3),
                      :end_date => Date.new(2014, 1, 6)
                      )

            
url = "http://www.pgatour.com/players.html"
page = Nokogiri::HTML(RestClient.get(url))

page.css("span.name").css("a").each do |link|
  attrs = {}

  url = "http://www.pgatour.com" + link["href"]
  attrs["url"] = url
  name = link.text.match(/(\w+)\W+(\w+)/)
  attrs["first_name"] = name[2]
  attrs["last_name"] = name[1]
  page = Nokogiri::HTML(RestClient.get(url))
  attrs["picture_url"] = page.css("ul.player-bio-cols").css("li.col1").css("img").attr("src").value
  categories = page.css("ul.player-bio-cols").css("li.col1").css("p")
  categories.each do |category|
    if category.css("span").text == "Weight"
      attrs["weight"] = category.text.match(/(\d+)/)[0].to_i
    elsif category.css("span").text == "Height"
      height = category.text.match(/(\d*)\D*(\d+)/)
      attrs["height"] = height[1].to_i*12 + height[2].to_i
    elsif category.css("span").text == "Birthday"
      bday = category.text.match(/(\d+)\/(\d+)\/(\d+)/)
      attrs["birthdate"] = Date.new(bday[3].to_i,bday[1].to_i,bday[2].to_i)
    end
  end
  p Player.create!(attrs)
end


rob = User.create!(:first_name => "Rob", :last_name => "Andrews", :email => "rob@gmail.com",
              :password => "password", :password_confirmation => "password")

RosterMembership.create!(:user_id => rob.id, :player_id => 20)
RosterMembership.create!(:user_id => rob.id, :player_id => 30)
RosterMembership.create!(:user_id => rob.id, :player_id => 40)

print"#######################################################\n"
p "Finished seeding database in #{Time.now - start} seconds"
print"#######################################################\n"