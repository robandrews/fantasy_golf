class ChangeColumnOnLeagueMembership < ActiveRecord::Migration
  def change
    change_column :league_memberships, :season_points, :float, :default => 0
  end
end
