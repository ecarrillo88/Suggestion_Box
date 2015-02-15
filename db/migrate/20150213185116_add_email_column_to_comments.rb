class AddEmailColumnToComments < ActiveRecord::Migration
  def change
    add_column :comments, :email, :string
  end
end
