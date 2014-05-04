class AddUserIdToFreeAgentOffers < ActiveRecord::Migration
  def change
    add_column :free_agent_offers, :league_membership_id, :integer
  end
end
