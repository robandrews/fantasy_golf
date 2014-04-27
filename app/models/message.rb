# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  sender_id  :integer
#  subject    :string(255)
#  body       :text
#  league_id  :integer
#  parent_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Message < ActiveRecord::Base
  validates :league_id, :subject, :body, presence: true
  
  belongs_to :sender,
  :class_name => "User",
  :foreign_key => :sender_id,
  :primary_key => :id
end
