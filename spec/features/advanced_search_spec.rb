require 'rails_helper'

RSpec.describe "Advanced Search", :type => :feature do
  before do
    Suggestion.create(category: 1, title: 'Suggestion 1', author: 'John Doe', email: 'John_Doe@email.com', comment: 'Lorem ipsum dolor sit amet', visible: true, closed: 0)
    Suggestion.create(category: 2, title: 'Suggestion 2', author: 'Jane Doe', email: 'Jane_Doe@email.com', comment: 'Consectetuer adipiscing elit', visible: true, closed: 0)
    Suggestion.create(category: 1, title: 'Suggestion 3', author: 'Joe Blow', email: 'Joe_Blow@email.com', comment: 'Aenean commodo ligula eget dolor', visible: true, closed: 0)
  end

  it "Go to advanced search page" do
    visit root_path

    click_link 'advanced-search-button'

    expect(page).to have_content I18n.t('suggestions.advanced_search.header_title')
  end

  it "Filtering suggestions", :js => true do
    visit advanced_search_path

    fill_in 'title', with: 'Suggestion'
    select I18n.t('suggestions.search_filter.category_1'), from: 'category'
    select I18n.t('suggestions.search_filter.status_open'), from: 'status'
    click_on I18n.t('suggestions.search_filter.search_button')

    expect(page).to have_selector('h2', text: 'Suggestion 1')
    expect(page).to have_selector('h2', text: 'Suggestion 3')
  end
end
