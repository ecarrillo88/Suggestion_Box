class AddLatitudeAndLongitudeColumnsToSuggestions < ActiveRecord::Migration
  def change
    add_column :suggestions, :latitude, :float
    add_column :suggestions, :longitude, :float
  end
end
