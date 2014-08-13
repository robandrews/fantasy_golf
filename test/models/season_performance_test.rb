# == Schema Information
#
# Table name: season_performances
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  season_id  :integer
#  points     :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class SeasonPerformanceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
