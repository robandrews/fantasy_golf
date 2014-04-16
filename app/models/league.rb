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
  has_many :league_memberships
  has_many :members, :through => :league_memberships, :source => :user
end
