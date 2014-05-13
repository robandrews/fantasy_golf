class AddLeagueIDtoRosterMembership < ActiveRecord::Migration
  def change
    add_column :roster_memberships, :league_id, :integer
  end
end
