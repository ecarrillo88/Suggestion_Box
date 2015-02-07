class AddSuggestionReferencesToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :suggestion, index: true
    add_foreign_key :comments, :suggestions
  end
end
