class AddColTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :complete, :boolean
  end
end
