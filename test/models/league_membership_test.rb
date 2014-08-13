# == Schema Information
#
# Table name: league_memberships
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  league_id          :integer
#  created_at         :datetime
#  updated_at         :datetime
#  season_points      :float            default(0.0)
#  name               :string(255)
#  ready              :boolean          default(FALSE)
#  monthly_fa_pickups :integer          default(0)
#  season_fa_pickups  :integer          default(0)
#  season_scores      :text
#

require 'test_helper'

class LeagueMembershipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
