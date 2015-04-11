class AddVoteColumnToComments < ActiveRecord::Migration
  def change
    add_column :comments, :vote, :integer
  end
end
