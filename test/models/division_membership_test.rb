# == Schema Information
#
# Table name: division_memberships
#
#  id                   :integer          not null, primary key
#  division_id          :integer
#  league_membership_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#

require 'test_helper'

class DivisionMembershipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
