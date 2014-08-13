# == Schema Information
#
# Table name: divisions
#
#  id         :integer          not null, primary key
#  league_id  :integer
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class DivisionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
