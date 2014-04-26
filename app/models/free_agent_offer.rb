# == Schema Information
#
# Table name: free_agent_offers
#
#  id          :integer          not null, primary key
#  player_id   :integer
#  expiry_date :datetime
#  created_at  :datetime
#  updated_at  :datetime
#  name        :string(255)
#  user_name   :string(255)
#  contested   :boolean          default(FALSE)
#

class FreeAgentOffer < ActiveRecord::Base
  has_many :interested_parties
  has_many :users, :through => :interested_parties, :source => :user
  belongs_to :player
end
