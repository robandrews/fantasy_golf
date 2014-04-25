class CreateFreeAgentOffers < ActiveRecord::Migration
  def change
    create_table :free_agent_offers do |t|
      t.integer :player_id
      t.datetime :expiry_date
      
      t.timestamps
    end
  end
end
