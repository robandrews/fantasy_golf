# == Schema Information
#
# Table name: players
#
#  id          :integer          not null, primary key
#  first_name  :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  url         :string(255)
#  picture_url :string(255)
#  birthdate   :date
#  weight      :integer
#  height      :integer
#  last_name   :string(255)
#

class Player < ActiveRecord::Base
  has_many :tournament_standings
  
  has_many :roster_memberships
  
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
