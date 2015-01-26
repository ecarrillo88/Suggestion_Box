class CreateSuggestions < ActiveRecord::Migration
  def change
    create_table :suggestions do |t|
      t.string :title
      t.string :author
      t.string :email
      t.text :comment

      t.timestamps null: false
    end
  end
end
