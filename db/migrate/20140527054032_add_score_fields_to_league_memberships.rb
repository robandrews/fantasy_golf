class AddScoreFieldsToLeagueMemberships < ActiveRecord::Migration
  def change
    add_column :league_memberships, :season_scores, :text
  end
end
