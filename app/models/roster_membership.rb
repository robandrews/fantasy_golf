# == Schema Information
#
# Table name: roster_memberships
#
#  id                   :integer          not null, primary key
#  league_membership_id :integer
#  player_id            :integer
#  created_at           :datetime
#  updated_at           :datetime
#  active               :boolean          default(FALSE)
#  league_id            :integer
#

class RosterMembership < ActiveRecord::Base
	belongs_to :league_membership 
	belongs_to :player
	belongs_to :league

	validates_uniqueness_of :player, :scope => :league_membership_id
  validates_uniqueness_of :player, :scope => :league_id
end
