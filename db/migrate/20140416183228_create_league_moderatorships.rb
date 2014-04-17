class CreateLeagueModeratorships < ActiveRecord::Migration
  def change
    create_table :league_moderatorships do |t|
      t.integer :league_id
      t.integer :user_id
      
      t.timestamps
    end
  end
end
