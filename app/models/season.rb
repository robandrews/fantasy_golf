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
#  slug       :string(255)
#

class Season < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_many :weeks
    
  validates :name, :start_date, {:presence => true, :uniqueness => true}
end
