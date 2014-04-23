# == Schema Information
#
# Table name: seasons
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  start_date :date
#  end_date   :date
#  created_at :datetime
#  updated_at :datetime
#  league_id  :integer
#

class Season < ActiveRecord::Base
  has_many :weeks
    
  validates :name, :start_date, :presence => true
end
