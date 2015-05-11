class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :suggestions, :type, :category
  end
end
