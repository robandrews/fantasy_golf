class CreateLeagueMemberships < ActiveRecord::Migration
  def change
    create_table :league_memberships do |t|
      t.integer :user_id
      t.integer :league_id
      
      t.timestamps
    end
  end
end
