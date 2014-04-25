class InterestedParty < ActiveRecord::Base
  belongs_to :user
  belongs_to :free_agent_offer
end
