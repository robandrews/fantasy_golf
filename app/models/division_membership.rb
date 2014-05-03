# == Schema Information
#
# Table name: division_memberships
#
#  id                   :integer          not null, primary key
#  division_id          :integer
#  league_membership_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#

class DivisionMembership < ActiveRecord::Base
  belongs_to :division
  belongs_to :league_membership
end
