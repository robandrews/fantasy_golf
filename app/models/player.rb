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
#  yahoo_id        :string(255)
#  birth_place     :string(255)
#  college         :string(255)
#  career_earnings :integer
#  playable        :boolean          default(TRUE)
#

class Player < ActiveRecord::Base
  has_many :tournament_standings,
  :class_name => "TournamentStanding",
  :foreign_key => :player_id,
  :primary_key => :yahoo_id
  
  has_many :roster_memberships
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
end
