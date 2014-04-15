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

#Write a crawler to populate list and with name and url
#should start at https://sports.yahoo.com/golf/pga/players?lname=a
#and iterate through lname=y


url = "http://www.pgatour.com/players.html"
page = Nokogiri::HTML(RestClient.get(url))

page.css("span.name").css("a").each do |link|
  attrs = {}

  url = "http://www.pgatour.com" + link["href"]
  attrs["url"] = url
  attrs["name"] = link.text
  
  page = Nokogiri::HTML(RestClient.get(url))
  attrs["picture_url"] = page.css("ul.player-bio-cols").css("li.col1").css("img").attr("src").value
  categories = page.css("ul.player-bio-cols").css("li.col1").css("p")
  p categories
  categories.each do |category|
    p category.css("span").text
    if category.css("span").text == "Weight"
      p category.text
      attrs["weight"] = category.text.match(/(\d+)/)[0].to_i
    elsif category.css("span").text == "Height"
      p category.text
      height = category.text.match(/(\d*)\D*(\d+)/)
      attrs["height"] = height[0].to_i*12 + height[1].to_i
    elsif category.css("span").text == "Birthday"
      p category.text
      bday = category.text.match(/(\d+)\/(\d+)\/(\d+)/)
      attrs["birthdate"] = Date.new(bday[3].to_i,bday[1].to_i,bday[2].to_i)
    end
  end
  p Player.create!(attrs)
end

print"#######################################################\n"
p "Finished seeding database in #{Time.now - start} seconds"
print"#######################################################\n"