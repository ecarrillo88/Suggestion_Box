require 'rails_helper'

RSpec.feature "Show Suggestion", type: :feature do
  scenario 'a suggestion has a page' do
    suggestion = Suggestion.create({category: Suggestion.category[:suggestion], title: 'Suggestion of the year', author: 'Anonymous', email: 'my_email@email.com', comment: 'My suggestion!', visible: true, image1_id: 1, image2_id: 1})

    visit suggestion_path(id: suggestion.id)

    expect(page).to have_css('.title', text: 'Suggestion of the year')
    expect(page).to have_css('.suggestion_img')
  end
end
