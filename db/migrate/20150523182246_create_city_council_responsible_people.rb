class CreateCityCouncilResponsiblePeople < ActiveRecord::Migration
  def change
    create_table :city_council_responsible_people do |t|
      t.string :name
      t.string :last_name
      t.string :email

      t.timestamps null: false
    end
  end
end
