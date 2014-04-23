class DeleteColumnFromLeague < ActiveRecord::Migration
  def change
    remove_column :seasons, :league_id
  end
end
