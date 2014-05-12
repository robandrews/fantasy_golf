class ChangeTournament < ActiveRecord::Migration
  def change
    change_column :tournaments, :start_date, :datetime
    change_column :tournaments, :end_date, :datetime
    
    add_index :roster_memberships, :league_membership_id
    add_index :roster_memberships, :player_id
    add_index :players, :yahoo_id
    add_index :messages, :league_id
    add_index :league_memberships, :user_id
    add_index :league_memberships, :league_id
  end
end
