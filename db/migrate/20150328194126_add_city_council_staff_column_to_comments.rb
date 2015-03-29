class AddCityCouncilStaffColumnToComments < ActiveRecord::Migration
  def change
    add_column :comments, :city_council_staff, :boolean, default: :false
  end
end
