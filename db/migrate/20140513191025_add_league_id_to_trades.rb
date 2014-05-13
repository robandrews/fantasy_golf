class AddLeagueIdToTrades < ActiveRecord::Migration
  def change
    add_column :trades, :league_id, :integer
    add_index :trades, :league_id
  end
end
