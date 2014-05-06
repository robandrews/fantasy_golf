# == Schema Information
#
# Table name: trade_groups
#
#  id                   :integer          not null, primary key
#  trade_id             :integer
#  league_membership_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#

class TradeGroup < ActiveRecord::Base
  belongs_to :trade
  belongs_to :league_membership
  
  has_many :trade_group_memberships
  has_many :players, :through => :trade_group_memberships
end
