# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string(255)
#  last_name              :string(255)
#  season_points          :float
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  has_many :roster_memberships
  has_many :players, :through => :roster_memberships, :source => :player
  has_many :league_memberships
  has_many :leagues, :through => :league_memberships
  has_many :league_moderatorships
  
  has_many :division_memberships
  
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable
  
  def initialize
    self.season_points = 0
  end    
  
  def name
    [self.first_name,self.last_name].join(" ")
  end
  
  # not working
  def score_week(week)
    tournaments = Week.find(week).tournaments
    points = 0
    self.players.each do |player|
      tournaments.each do |tournament|
        place = player.tournament_standings.where("tournament_id = ? AND yahoo_id = ?",
            tournament.id, player.yahoo_id).first
        points += place.fantasy_points unless place.nil?
      end
    end
    p ("#{self.name} now has #{points}")
  end  
  
  def incremenet_score(num)
    self.season_points += num
  end
end
