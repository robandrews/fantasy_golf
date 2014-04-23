# == Schema Information
#
# Table name: leagues
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  secret_sauce :string(255)
#  slug         :string(255)
#

class League < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, :presence => true
  before_save :make_secret_sauce
  
  has_many :league_memberships
  has_many :members, :through => :league_memberships, :source => :user
  has_many :league_moderatorships
  has_many :moderators, :through => :league_moderatorships, :source => :user
  
  has_many :divisions
  
  def make_secret_sauce
    self.secret_sauce = SecureRandom.base64(16)
  end
end
