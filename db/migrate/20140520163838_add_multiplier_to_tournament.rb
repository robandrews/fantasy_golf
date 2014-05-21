class AddMultiplierToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :multiplier, :float
  end
end
