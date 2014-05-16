class AddCreatorIdToFreeAgentOffer < ActiveRecord::Migration
  def change
    add_column :free_agent_offers, :creator_league_membership_id, :integer
  end
end
