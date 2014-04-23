class AddSlugToLeague < ActiveRecord::Migration

  def change
    add_column :leagues, :slug, :string
    add_index :leagues, :slug, :unique => true
  end
end
