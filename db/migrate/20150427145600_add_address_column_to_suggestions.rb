class AddAddressColumnToSuggestions < ActiveRecord::Migration
  def change
    add_column :suggestions, :address, :string
  end
end
