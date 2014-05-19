class AddReadyToLeagueMemberships < ActiveRecord::Migration
  def change
    add_column :league_memberships, :ready, :boolean, :default => false
  end
end
