class CreateBylaws < ActiveRecord::Migration
  def change
    create_table :bylaws do |t|
      t.integer :league_id
      t.text :body
      
      t.timestamps
    end
  end
end
