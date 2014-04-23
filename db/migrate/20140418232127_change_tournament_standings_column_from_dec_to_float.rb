class ChangeTournamentStandingsColumnFromDecToFloat < ActiveRecord::Migration
  def change
    change_column :tournament_standings, :fantasy_points, :float
  end
end
