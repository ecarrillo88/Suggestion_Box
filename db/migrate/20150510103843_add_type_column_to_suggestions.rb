class AddTypeColumnToSuggestions < ActiveRecord::Migration
  def change
    add_column :suggestions, :type, :string
  end
end
