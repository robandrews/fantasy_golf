# == Schema Information
#
# Table name: league_moderatorships
#
#  id         :integer          not null, primary key
#  league_id  :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class LeagueModeratorshipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
