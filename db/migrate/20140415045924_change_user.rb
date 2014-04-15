class ChangeUser < ActiveRecord::Migration
  def change
    add_column :players, :picture_url, :string
    add_column :players, :birthdate, :date
    add_column :players, :weight, :integer
    add_column :players, :height, :integer

  end
end
