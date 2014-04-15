class CreateTournamentStandings < ActiveRecord::Migration
  def change
    create_table :tournament_standings do |t|
      t.integer :player_id
      t.integer :tournament_id
      t.integer :winnings
      t.string :to_par
      t.string :position
      
      t.timestamps
    end
    add_index :tournament_standings, :player_id
    add_index :tournament_standings, :tournament_id
  end
end
