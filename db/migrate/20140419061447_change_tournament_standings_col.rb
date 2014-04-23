class ChangeTournamentStandingsCol < ActiveRecord::Migration
  def change
    add_column :tournament_standings, :yahoo_id, :integer
  end
end
