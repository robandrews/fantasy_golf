class RenameColumnInTournaments < ActiveRecord::Migration
  def change
    rename_column :tournaments, :season_id, :week_id
    remove_column :tournaments, :week
  end
end
