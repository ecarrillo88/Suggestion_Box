require 'rails_helper'

RSpec.describe Suggestion, type: :model do

  before(:each) do
    @suggestion1 = Suggestion.create({category: Suggestion.category[:suggestion], title: 'Suggestion of the year', author: 'Anonymous', email: 'my_email@email.com', comment: 'My suggestion!', latitude: 40.4167754, longitude: -3.7037901999999576})
    @suggestion2 = Suggestion.create({category: Suggestion.category[:complaint], title: 'Complaint', author: 'Anonymous', email: 'my_email@email.com', comment: 'My complaint!', latitude: 40.3963198127118, longitude: -3.716254234313965})
  end

  context "search_filter" do
    it "should filter by category" do
      category = Suggestion.category[:suggestion]
      title = nil
      address = nil
      distance = nil
      suggestion = Suggestion.search_filter(category, title, address, distance)
      expect(suggestion.first).to eq(@suggestion1)
    end

    it "should filter by title" do
      suggestion = Suggestion.search_filter(nil, 'Suggestion', nil, nil)
      expect(suggestion.first).to eq(@suggestion1)
    end

    it "should filter by title with multiple words" do
      suggestion = Suggestion.search_filter(nil, 'Suggestion the', nil, nil)
      expect(suggestion.first).to eq(@suggestion1)
    end

    it "should filter by address" do
      suggestion = Suggestion.search_filter(nil, nil, 'Puerta del Sol Madrid', 0.5)
      expect(suggestion.first).to eq(@suggestion1)
    end

    it "should filter by distance" do
      suggestions = Suggestion.search_filter(nil, nil, 'Puerta del Sol Madrid', 10)
      expect(suggestions).to eq([@suggestion1, @suggestion2])
    end

    it "should filter by category, title and address" do
      suggestion = Suggestion.search_filter(Suggestion.category[:complaint], 'Complaint', 'Calle Fuenlabrada Madrid', 0.5)
      expect(suggestion.first).to eq(@suggestion2)
    end
  end
end
