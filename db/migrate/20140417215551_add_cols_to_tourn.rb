class AddColsToTourn < ActiveRecord::Migration
  def change
    add_column :tournaments, :season_id, :integer
    add_column :tournaments, :week, :integer
  end
end
