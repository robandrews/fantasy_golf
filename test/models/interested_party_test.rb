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

require 'test_helper'

class InterestedPartyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
