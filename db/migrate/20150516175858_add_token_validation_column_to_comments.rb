class AddTokenValidationColumnToComments < ActiveRecord::Migration
  def change
    add_column :comments, :token_validation, :string
  end
end
