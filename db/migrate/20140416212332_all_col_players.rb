class AllColPlayers < ActiveRecord::Migration
  def change
    add_column :players, :playable, :boolean, :default => true
  end
end
