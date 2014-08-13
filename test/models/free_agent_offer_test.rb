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

require 'test_helper'

class FreeAgentOfferTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
