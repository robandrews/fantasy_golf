class AddColumnstoLeagueMembership < ActiveRecord::Migration
  def change
    add_column :league_memberships, :season_points, :integer
    add_column :league_memberships, :name, :string
    remove_column :users, :season_points
  end
end
