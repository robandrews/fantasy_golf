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
#  monthly_fa_pickups :integer          default(0)
#  season_fa_pickups  :integer          default(0)
#  season_scores      :text
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
  
  def valid_roster?
    active, bench = get_active_and_bench_players
    return true if active.length == 4 and active.length + bench.length <= 7
    false
  end
  
  def tournament_names
    JSON.parse(self.season_scores.html_safe).map{|tourn_arr, pts| tourn_arr[0]}.to_json
  end
  
  def calculate_season_points_from_season_scores
    JSON.parse(self.season_scores).inject(0){|s, arr| s += arr[1].to_f}
  end
end
