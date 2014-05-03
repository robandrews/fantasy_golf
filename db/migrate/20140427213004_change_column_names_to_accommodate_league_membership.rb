class ChangeColumnNamesToAccommodateLeagueMembership < ActiveRecord::Migration
  def change
    rename_column :roster_memberships, :user_id, :league_membership_id
    rename_column :interested_parties, :user_id, :league_membership_id
    rename_column :division_memberships, :user_id, :league_membership_id
  end
end
