class AddImageIdColumnsToSuggestions < ActiveRecord::Migration
  def change
    add_column :suggestions, :image1_id, :string
    add_column :suggestions, :image2_id, :string
  end
end
