# == Schema Information
#
# Table name: interested_parties
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  free_agent_offer_id :integer
#  created_at          :datetime
#  updated_at          :datetime
#

class InterestedParty < ActiveRecord::Base
  belongs_to :user
  belongs_to :free_agent_offer
end
