class FreeAgentOffer < ActiveRecord::Base
  has_many :interested_parties
  has_many :users, :through => :interested_parties, :source => :user
  has_one :player
end
