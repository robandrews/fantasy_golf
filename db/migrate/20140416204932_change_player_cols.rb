class ChangePlayerCols < ActiveRecord::Migration
  def change
    add_column :players, :yahoo_id, :string
    add_column :players, :birth_place, :string
    add_column :players, :college, :string
    add_column :players, :career_earnings, :integer
  end
end
