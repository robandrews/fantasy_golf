class AddColumnToRosterMembership < ActiveRecord::Migration
  def change
    add_column :roster_memberships, :active, :boolean, :default => false
  end
end
