require 'rails_helper'

RSpec.feature "CreateSuggestions", type: :feature do
  background do
    WhiteListEmail.new(email: 'JohnnyStorm@fantastic4.com').save
  end

  scenario 'Create a new suggestion' do
    visit root_path(locale: :en)
    first(:link, I18n.t('header.new_suggestion_button')).click
    expect(page).to have_text I18n.t('suggestions.new.header_title')

    fill_in 'suggestion_title',   with: 'Fantastic Suggestion'
    select  'Suggestion',         from: 'suggestion_category'
    fill_in 'suggestion_author',  with: 'Human Torch'
    fill_in 'suggestion_email',   with: 'JohnnyStorm@fantastic4.com'
    fill_in 'suggestion_comment', with: 'Lorem ipsum dolor sit amet'
    click_button I18n.t('suggestions.form.create_suggestion_button')

    expect(page).to have_text I18n.t('suggestions.show.header_title')
    expect(page).to have_text I18n.t('suggestions.create.flash_create_ok')
    expect(page).to have_text 'Fantastic Suggestion'

    visit root_path(locale: :en)
    expect(page).to have_text 'Fantastic Suggestion'
  end
end
