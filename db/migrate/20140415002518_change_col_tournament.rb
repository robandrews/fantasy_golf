class ChangeColTournament < ActiveRecord::Migration
  def change
    rename_column :tournaments, :tournament_url, :url
  end
end
