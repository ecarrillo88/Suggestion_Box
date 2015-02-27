class AddSupportColumnToComments < ActiveRecord::Migration
  def change
    add_column :comments, :support, :boolean, default: :false
  end
end
