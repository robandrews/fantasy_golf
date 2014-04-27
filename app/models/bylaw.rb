# == Schema Information
#
# Table name: bylaws
#
#  id         :integer          not null, primary key
#  league_id  :integer
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

class Bylaw < ActiveRecord::Base
end
