# == Schema Information
#
# Table name: free_agent_offers
#
#  id                           :integer          not null, primary key
#  player_id                    :integer
#  expiry_date                  :datetime
#  created_at                   :datetime
#  updated_at                   :datetime
#  name                         :string(255)
#  user_name                    :string(255)
#  contested                    :boolean          default(FALSE)
#  creator_league_membership_id :integer
#  league_id                    :integer
#  completed                    :boolean          default(FALSE)
#

class FreeAgentOffer < ActiveRecord::Base
  has_many :interested_parties
  has_many :users, :through => :interested_parties, :source => :league_membership
  belongs_to :player
  
  validates_uniqueness_of :player_id, :scope => :creator_league_membership_id
end
