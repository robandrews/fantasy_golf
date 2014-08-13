# == Schema Information
#
# Table name: tournament_standings
#
#  id             :integer          not null, primary key
#  player_id      :integer
#  tournament_id  :integer
#  winnings       :integer
#  to_par         :string(255)
#  position       :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  fantasy_points :float
#  int_position   :integer
#  yahoo_id       :integer
#

require 'test_helper'

class TournamentStandingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
