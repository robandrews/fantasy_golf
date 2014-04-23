# == Schema Information
#
# Table name: weeks
#
#  id         :integer          not null, primary key
#  season_id  :integer
#  created_at :datetime
#  updated_at :datetime
#  order      :integer
#

class Week < ActiveRecord::Base
  has_many :tournaments
  belongs_to :season
end
