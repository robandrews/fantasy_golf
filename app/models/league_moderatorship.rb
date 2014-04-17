# == Schema Information
#
# Table name: league_moderatorships
#
#  id         :integer          not null, primary key
#  league_id  :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class LeagueModeratorship < ActiveRecord::Base
  belongs_to :user
  belongs_to :league
end
