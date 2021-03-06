# == Schema Information
#
# Table name: weeks
#
#  id         :integer          not null, primary key
#  season_id  :integer
#  created_at :datetime
#  updated_at :datetime
#  week_order :integer
#  start_time :datetime
#  end_time   :datetime
#

class Week < ActiveRecord::Base
  has_many :tournaments
  belongs_to :season
end
