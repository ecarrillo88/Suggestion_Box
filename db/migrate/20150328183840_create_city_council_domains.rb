class CreateCityCouncilDomains < ActiveRecord::Migration
  def change
    create_table :city_council_domains do |t|
      t.string :domain

      t.timestamps null: false
    end
  end
end
