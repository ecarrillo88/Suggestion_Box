class AddClosedColumnToSuggestions < ActiveRecord::Migration
  def change
    add_column :suggestions, :closed, :boolean, default: :false
  end
end
