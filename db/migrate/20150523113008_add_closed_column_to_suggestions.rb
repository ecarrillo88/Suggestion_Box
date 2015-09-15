class AddClosedColumnToSuggestions < ActiveRecord::Migration
  def change
    add_column :suggestions, :closed, :integer, default: 0
  end
end
