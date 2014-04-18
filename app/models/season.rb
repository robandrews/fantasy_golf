# == Schema Information
#
# Table name: seasons
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class Season < ActiveRecord::Base
  has_many :tournaments
  
  validates :name, :start_date, :presence => true
end
