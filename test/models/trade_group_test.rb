# == Schema Information
#
# Table name: trade_groups
#
#  id                   :integer          not null, primary key
#  trade_id             :integer
#  league_membership_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#

require 'test_helper'

class TradeGroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
