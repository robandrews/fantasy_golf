class AddStartEndToWeeks < ActiveRecord::Migration
  def change
    add_column :weeks, :start_time, :datetime
    add_column :weeks, :end_time, :datetime
    add_index :weeks, :start_time
    add_index :weeks, :end_time
  end
end
