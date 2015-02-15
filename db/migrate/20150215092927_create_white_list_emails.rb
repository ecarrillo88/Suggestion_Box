class CreateWhiteListEmails < ActiveRecord::Migration
  def change
    create_table :white_list_emails do |t|
      t.string :email

      t.timestamps null: false
    end
  end
end
