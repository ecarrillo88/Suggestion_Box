require 'rails_helper'

RSpec.feature "CreateComments", type: :feature do
  
  background do
    @suggestion = Suggestion.create(title:   'Awesome Suggestion',
                                    author:  'Mister Fantastic',
                                    email:   'ReedRichards@email.com',
                                    comment: 'Lorem ipsum dolor sit amet')
    WhiteListEmail.new(email: 'SusanStorm@email.com').save
  end
  
  scenario 'Create a new comment' do
    visit suggestion_path(@suggestion)
    expect(page).to have_text 'Showing Suggestion'
    expect(page).to have_text 'Awesome Suggestion'

    fill_in 'Name',    with: 'Invisible Woman'
    fill_in 'Email',   with: 'SusanStorm@email.com'
    fill_in 'Comment', with: 'Aenean commodo ligula eget dolor'
    click_button 'Comment'

    expect(page).to have_text 'Showing Suggestion'
    expect(page).to have_text 'Awesome Suggestion'
    expect(page).to have_text 'Aenean commodo ligula eget dolor'
  end
end
