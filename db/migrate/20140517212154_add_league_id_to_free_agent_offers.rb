class AddLeagueIdToFreeAgentOffers < ActiveRecord::Migration
  def change
    add_column :free_agent_offers, :league_id, :integer
    add_column :free_agent_offers, :completed, :boolean, :default => false
    add_index :free_agent_offers, :league_id
    add_index :free_agent_offers, :completed
  end
end
