require 'rails_helper'

RSpec.feature "CreateComments", type: :feature do

  background do
    @suggestion = Suggestion.create(category: 1, title: 'Awesome Suggestion', author: 'Mister Fantastic', email: 'ReedRichards@email.com', comment: 'Lorem ipsum dolor sit amet', visible: true)
    WhiteListEmail.new(email: 'SusanStorm@email.com').save
  end

  scenario 'Create a new comment as a neighbor' do
    visit suggestion_path(@suggestion, locale: :en)
    expect(page).to have_text I18n.t('suggestions.show.header_title')
    expect(page).to have_text 'Awesome Suggestion'

    fill_in I18n.t('comments.form.name_field'),    with: 'Invisible Woman'
    fill_in I18n.t('comments.form.email_field'),   with: 'SusanStorm@email.com'
    fill_in I18n.t('comments.form.comment_field'), with: 'Aenean commodo ligula eget dolor'
    click_button I18n.t('comments.form.comment_button')

    expect(page).to have_text I18n.t('suggestions.show.header_title')
    expect(page).to have_text 'Awesome Suggestion'
    expect(page).to have_text 'Aenean commodo ligula eget dolor'
    expect(page).to have_css 'div.comment'
  end

  background do
    @suggestion.comments.create(author: 'The Thing', email: 'BenjaminGrimm@city_council.gov', text: 'In maximus dolor et urna convallis, a porta tellus ullamcorper.',
                                city_council_staff: true, visible: true, vote: Comment.vote[:abstention])
  end

  scenario 'Check comment created by city council staff when already validated' do
    visit suggestion_path(@suggestion, locale: :en)
    expect(page).to have_text I18n.t('suggestions.show.header_title')
    expect(page).to have_text 'Awesome Suggestion'

    expect(page).to have_text I18n.t('suggestions.show.header_title')
    expect(page).to have_text 'Awesome Suggestion'
    expect(page).to have_text 'The Thing'
    expect(page).to have_css 'div.comment-city-council-staff'
  end
end
