class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.string :subject
      t.text :body
      t.integer :league_id
      t.integer :parent_id

      t.timestamps
    end
  end
end
