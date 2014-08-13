# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  sender_id   :integer
#  subject     :string(255)
#  body        :text
#  league_id   :integer
#  parent_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#  sender_name :string(255)
#

require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
