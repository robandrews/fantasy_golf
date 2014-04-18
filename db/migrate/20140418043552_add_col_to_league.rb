class AddColToLeague < ActiveRecord::Migration
  def change
    add_column :leagues, :secret_sauce, :string
  end
end
