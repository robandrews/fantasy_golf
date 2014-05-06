class CreateTradeGroupMemberships < ActiveRecord::Migration
  def change
    create_table :trade_group_memberships do |t|
      t.integer :player_id
      t.integer :trade_group_id
      
      t.timestamps
    end
  end
end
