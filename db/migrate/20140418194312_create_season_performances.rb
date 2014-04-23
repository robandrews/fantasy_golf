class CreateSeasonPerformances < ActiveRecord::Migration
  def change
    create_table :season_performances do |t|
      t.integer :user_id
      t.integer :season_id
      t.integer :points

      t.timestamps
    end
  end
end
