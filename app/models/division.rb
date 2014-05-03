# == Schema Information
#
# Table name: divisions
#
#  id         :integer          not null, primary key
#  league_id  :integer
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Division < ActiveRecord::Base
  belongs_to :league
  has_many :division_memberships
  has_many :members, :through => :division_memberships, :source => :league_membership
  
  validates :name, :presence => true
end
