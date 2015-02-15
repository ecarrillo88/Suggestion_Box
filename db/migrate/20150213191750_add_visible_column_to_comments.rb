class AddVisibleColumnToComments < ActiveRecord::Migration
  def change
    add_column :comments, :visible, :boolean, default: :false
  end
end
