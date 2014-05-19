class AddFaColumnsToLeagueMemberships < ActiveRecord::Migration
  def change
    add_column :league_memberships, :monthly_fa_pickups, :integer, :default => 0
    add_column :league_memberships, :season_fa_pickups, :integer, :default => 0
  end
end
