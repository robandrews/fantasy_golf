class AddScoreToUser < ActiveRecord::Migration
  def change
    add_column :users, :season_points, :float
  end
end
