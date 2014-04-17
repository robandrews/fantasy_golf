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

rob = User.create!(:first_name => "Rob", :last_name => "Andrews", :email => "rob@gmail.com",
:password => "password", :password_confirmation => "password")

RosterMembership.create!(:user_id => rob.id, :player_id => 20)
RosterMembership.create!(:user_id => rob.id, :player_id => 30)
RosterMembership.create!(:user_id => rob.id, :player_id => 40)

league = League.create!(:name => "The League")

LeagueMembership.create!(:user_id => rob.id, :league_id => league.id)
print"#######################################################\n"
p "Finished seeding database in #{Time.now - start} seconds"
print"#######################################################\n"