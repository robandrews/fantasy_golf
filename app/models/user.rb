# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string(255)
#  last_name              :string(255)
#  season_points          :float            default(0.0)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  
  has_many :roster_memberships
  has_many :players, :through => :roster_memberships, :source => :player
  has_many :league_memberships
  has_many :leagues, :through => :league_memberships
  has_many :league_moderatorships
  has_many :division_memberships
  has_many :interested_parties

  has_many :messages,
  :class_name => "Message",
  :foreign_key => :sender_id,
  :primary_key => :id
  
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable
  
  def name
    [self.first_name,self.last_name].join(" ")
  end
end
