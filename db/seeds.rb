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

suggestion = Suggestion.create({category: Suggestion.category[:suggestion], title: 'Suggestion of the year', author: 'Anonymous', email: 'my_email@email.com', comment: 'My suggestion!', latitude: nil, longitude: nil, visible: true, closed: 0, image1_id: 1, image2_id: 1})
Comment.create(suggestion: suggestion, visible:true, email: 'my_other_email@email.com', vote: Comment::IN_FAVOUR, support: true, author: 'A real person!', text: 'Hey this is a comment')
