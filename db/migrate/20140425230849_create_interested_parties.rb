class CreateInterestedParties < ActiveRecord::Migration
  def change
    create_table :interested_parties do |t|
      t.integer :user_id
      t.integer :free_agent_offer_id
      
      t.timestamps
    end
  end
end
