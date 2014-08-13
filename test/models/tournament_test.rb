# == Schema Information
#
# Table name: tournaments
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  start_date :datetime
#  end_date   :datetime
#  url        :string(255)
#  created_at :datetime
#  updated_at :datetime
#  complete   :boolean
#  week_id    :integer
#  multiplier :float
#

require 'test_helper'

class TournamentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
