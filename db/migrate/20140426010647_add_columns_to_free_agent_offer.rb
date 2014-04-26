class AddColumnsToFreeAgentOffer < ActiveRecord::Migration
  def change
    add_column :free_agent_offers, :name, :string
    add_column :free_agent_offers, :user_name, :string
    add_column :free_agent_offers, :contested, :boolean, :default => false
  end
end
