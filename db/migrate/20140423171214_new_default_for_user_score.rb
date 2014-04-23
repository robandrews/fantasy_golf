class NewDefaultForUserScore < ActiveRecord::Migration
  def change
    change_column_default :users, :season_points, 0.0
  end
end
