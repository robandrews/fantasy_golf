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

require 'test_helper'

class RosterMembershipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
