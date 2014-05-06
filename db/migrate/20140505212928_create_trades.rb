class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.integer :proposer_id
      t.integer :proposee_id
      t.boolean :accepted, :default => false
      t.boolean :pending, :default => true
      
      t.timestamps
    end
  end
end
