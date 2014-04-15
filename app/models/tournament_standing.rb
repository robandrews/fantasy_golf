# == Schema Information
#
# Table name: tournament_standings
#
#  id            :integer          not null, primary key
#  player_id     :integer
#  tournament_id :integer
#  winnings      :integer
#  to_par        :string(255)
#  position      :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class TournamentStanding < ActiveRecord::Base
  
  belongs_to :tournament
end
