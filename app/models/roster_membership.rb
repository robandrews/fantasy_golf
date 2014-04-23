# == Schema Information
#
# Table name: roster_memberships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  player_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class RosterMembership < ActiveRecord::Base
  belongs_to :user 
  belongs_to :player
  
  validates :player_id, :uniqueness => :true
end