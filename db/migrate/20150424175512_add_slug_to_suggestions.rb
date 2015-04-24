class AddSlugToSuggestions < ActiveRecord::Migration
  def change
    add_column :suggestions, :slug, :string
    add_index :suggestions, :slug
  end
end
