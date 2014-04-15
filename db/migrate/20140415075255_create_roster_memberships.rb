class CreateRosterMemberships < ActiveRecord::Migration
  def change
    create_table :roster_memberships do |t|
      t.integer :user_id
      t.integer :player_id
      
      t.timestamps
    end
  end
end
