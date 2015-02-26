require 'rails_helper'

RSpec.feature "CreateSuggestions", type: :feature do
  background do
    WhiteListEmail.new(email: 'JohnnyStorm@email.com').save
  end
  
  scenario 'Create a new suggestion' do
    visit root_path
    click_link 'Create a new Suggestion'
    expect(page).to have_text 'New Suggestion'

    fill_in 'Title',   with: 'Fantastic Suggestion'
    fill_in 'Author',  with: 'Human Torch'
    fill_in 'Email',   with: 'JohnnyStorm@email.com'
    fill_in 'Comment', with: 'Lorem ipsum dolor sit amet'
    click_button 'Create Suggestion'

    expect(page).to have_text 'Showing Suggestion'
    expect(page).to have_text 'Suggestion was successfully published.'
    expect(page).to have_text 'Fantastic Suggestion'
    
    visit root_path
    expect(page).to have_text 'Fantastic Suggestion'
  end
end
