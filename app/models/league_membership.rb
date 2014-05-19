# == Schema Information
#
# Table name: league_memberships
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  league_id          :integer
#  created_at         :datetime
#  updated_at         :datetime
#  season_points      :float            default(0.0)
#  name               :string(255)
#  ready              :boolean          default(FALSE)
#  monthly_fa_pickups :integer
#  season_fa_pickups  :integer
#

class LeagueMembership < ActiveRecord::Base  
  belongs_to :league
  belongs_to :user
  
  has_many :division_memberships
  has_many :interested_parties
  has_many :roster_memberships
  has_many :players, :through => :roster_memberships, :source => :player

  has_many :messages,
  :class_name => "Message",
  :foreign_key => :sender_id,
  :primary_key => :id
  
  def get_active_and_bench_players
    active = self.roster_memberships.where(:active => true)
    bench = self.roster_memberships.where(:active => false)
    active_players = {}
    bench_players = {}
    
    active.each do |roster_membership|
      active_players[roster_membership] = Player.find(roster_membership.player_id)
    end
    
    bench.each do |roster_membership|
      bench_players[roster_membership] = Player.find(roster_membership.player_id)
    end
    
    [active_players, bench_players]
  end
end
