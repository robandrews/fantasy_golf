class Addcolumntotournament < ActiveRecord::Migration
  def change
    add_column :tournament_standings, :int_position, :integer
  end
end
