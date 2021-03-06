# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

CityCouncilDomain.create(domain: 'city_council.gov') # development
CityCouncilDomain.create(domain: 'mailinator.com')   # prodution
CityCouncilResponsiblePerson.create(name: 'Juan', last_name: 'Pardo Gutierrez', email: 'juanpardo@email.com')     # development
CityCouncilResponsiblePerson.create(name: 'Maria', last_name: 'Pérez García', email: 'mariaperez@mailinator.com') # prodution
