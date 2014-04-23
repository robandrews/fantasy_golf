class ChangecolnameinWeeks < ActiveRecord::Migration
  def change
    rename_column :weeks, :order, :week_order
  end
end
