# == Schema Information
#
# Table name: trades
#
#  id          :integer          not null, primary key
#  proposer_id :integer
#  proposee_id :integer
#  accepted    :boolean          default(FALSE)
#  pending     :boolean          default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#  league_id   :integer
#

require 'test_helper'

class TradeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
