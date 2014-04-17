class ChangeYahooIdToInt < ActiveRecord::Migration
  def change
    add_column :players, :yahoo_temp, :integer
    
    Player.all.each do |player|
      player.yahoo_temp = player.yahoo_id.to_i
    end
    
    remove_column :players, :yahoo_id
    rename_column :players, :yahoo_temp, :yahoo_id
  end
end
