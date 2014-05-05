# == Schema Information
#
# Table name: interested_parties
#
#  id                   :integer          not null, primary key
#  league_membership_id :integer
#  free_agent_offer_id  :integer
#  created_at           :datetime
#  updated_at           :datetime
#

class InterestedParty < ActiveRecord::Base
  belongs_to :league_membership
  belongs_to :free_agent_offer
  
  validates_uniqueness_of :free_agent_offer_id, :scope => :league_membership_id
end
