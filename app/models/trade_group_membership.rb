# == Schema Information
#
# Table name: trade_group_memberships
#
#  id             :integer          not null, primary key
#  player_id      :integer
#  trade_group_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class TradeGroupMembership < ActiveRecord::Base
  belongs_to :player
  belongs_to :trade_group
end
