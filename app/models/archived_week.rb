# == Schema Information
#
# Table name: archived_weeks
#
#  id         :integer          not null, primary key
#  league_id  :integer
#  season_id  :integer
#  week_id    :integer
#  roster     :text
#  created_at :datetime
#  updated_at :datetime
#

class ArchivedWeek < ActiveRecord::Base
end
