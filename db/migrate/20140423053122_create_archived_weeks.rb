class CreateArchivedWeeks < ActiveRecord::Migration
  def change
    create_table :archived_weeks do |t|
      t.integer :league_id
      t.integer :season_id
      t.integer :week_id
      t.text :roster

      t.timestamps
    end
    
    add_index :archived_weeks, :league_id
    add_index :archived_weeks, :week_id
  end
end
