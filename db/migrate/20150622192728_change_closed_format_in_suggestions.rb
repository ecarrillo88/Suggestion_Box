class ChangeClosedFormatInSuggestions < ActiveRecord::Migration
  def change
    change_column :suggestions, :closed, :integer, default: 0
  end
end
