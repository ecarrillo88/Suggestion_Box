class AddTokenValidationAndVisibleColumnsToSuggestions < ActiveRecord::Migration
  def change
    add_column :suggestions, :token_validation, :string
    add_column :suggestions, :visible, :boolean, default: :false
  end
end
