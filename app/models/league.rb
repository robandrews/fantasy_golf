# == Schema Information
#
# Table name: leagues
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class League < ActiveRecord::Base
  validates :name, :presence => true
  
  has_many :league_memberships
  has_many :members, :through => :league_memberships, :source => :user
  has_many :league_moderatorships
  has_many :moderators, :through => :league_moderatorships, :source => :user
end
