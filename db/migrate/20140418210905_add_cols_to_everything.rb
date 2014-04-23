class AddColsToEverything < ActiveRecord::Migration
  def change
    add_column :seasons, :league_id, :integer
  end
end
