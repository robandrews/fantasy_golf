# == Schema Information
#
# Table name: league_memberships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  league_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class LeagueMembership < ActiveRecord::Base  
  belongs_to :league
  belongs_to :user
end
