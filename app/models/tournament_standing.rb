# == Schema Information
#
# Table name: tournament_standings
#
#  id             :integer          not null, primary key
#  player_id      :integer
#  tournament_id  :integer
#  winnings       :integer
#  to_par         :string(255)
#  position       :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  fantasy_points :float
#  int_position   :integer
#  yahoo_id       :integer
#

class TournamentStanding < ActiveRecord::Base  
  belongs_to :tournament
  
  belongs_to :player,
  :class_name => "Player",
  :foreign_key => :player_id,
  :primary_key => :yahoo_id
    
  validates :tournament_id, :winnings, presence: true
end
