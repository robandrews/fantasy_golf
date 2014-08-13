# == Schema Information
#
# Table name: bylaws
#
#  id         :integer          not null, primary key
#  league_id  :integer
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class BylawTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
