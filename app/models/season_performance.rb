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

class SeasonPerformance < ActiveRecord::Base
  belongs_to :user
  belongs_to :season
end
