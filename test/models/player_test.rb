# == Schema Information
#
# Table name: players
#
#  id              :integer          not null, primary key
#  first_name      :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  url             :string(255)
#  picture_url     :string(255)
#  birthdate       :date
#  weight          :integer
#  height          :integer
#  last_name       :string(255)
#  birth_place     :string(255)
#  college         :string(255)
#  career_earnings :integer
#  playable        :boolean          default(TRUE)
#  yahoo_id        :integer
#  twitter         :string(255)
#

require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
