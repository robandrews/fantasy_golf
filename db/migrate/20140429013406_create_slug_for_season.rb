class CreateSlugForSeason < ActiveRecord::Migration
  def change
    add_column :seasons, :slug, :string
  end
end
