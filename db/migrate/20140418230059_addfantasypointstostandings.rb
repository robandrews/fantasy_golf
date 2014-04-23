class Addfantasypointstostandings < ActiveRecord::Migration
  def change
    add_column :tournament_standings, :fantasy_points, :decimal
  end
end
