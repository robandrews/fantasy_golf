class CreateTradeGroups < ActiveRecord::Migration
  def change
    create_table :trade_groups do |t|
      t.integer :trade_id
      t.integer :league_membership_id
      
      t.timestamps
    end
  end
end
