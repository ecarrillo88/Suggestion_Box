class AddNoticeOfInactivityColumnToSuggestions < ActiveRecord::Migration
  def change
    add_column :suggestions, :notice_of_inactivity, :boolean, default: :false
  end
end
