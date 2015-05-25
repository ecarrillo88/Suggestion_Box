require 'rails_helper'

RSpec.describe Suggestion, type: :model do

  before(:each) do
    @suggestion1 = Suggestion.create({category: Suggestion.category[:suggestion], title: 'Suggestion of the year', author: 'Anonymous', email: 'my_email@email.com', comment: 'My suggestion!', latitude: nil, longitude: nil, visible: true})
    @suggestion2 = Suggestion.create({category: Suggestion.category[:complaint], title: 'Complaint', author: 'Anonymous', email: 'my_email@email.com', comment: 'My complaint!', latitude: nil, longitude: nil, visible: true})
    @suggestion3 = Suggestion.create({category: Suggestion.category[:suggestion], title: 'Suggestion', author: 'Anonymous', email: 'my_email@email.com', comment: 'Another suggestion', latitude: nil, longitude: nil, visible: true})
  end

  context "search_filter" do
    it "should show all suggestions" do
      category = nil
      title = nil
      address = nil
      distance = nil
      suggestions = Suggestion.search_filter(category, title, address, distance)
      expect(suggestions).to eq([@suggestion3, @suggestion2, @suggestion1])
    end

    it "should filter by category" do
      suggestion = Suggestion.search_filter(Suggestion.category[:complaint], nil, nil, nil)
      expect(suggestion).to eq([@suggestion2])
    end

    it "should filter by title" do
      suggestion = Suggestion.search_filter(nil, 'Suggestion of the year', nil, nil)
      expect(suggestion).to eq([@suggestion1])
    end

    it "should filter by title with multiple words" do
      suggestion = Suggestion.search_filter(nil, 'Suggestion', nil, nil)
      expect(suggestion).to eq([@suggestion3, @suggestion1])
    end
  end
end
