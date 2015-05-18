require 'rails_helper'

RSpec.describe Suggestion, type: :model do

  before(:each) do
    @suggestion1 = Suggestion.create({category: Suggestion.category[:suggestion], title: 'Suggestion', author: 'Anonymous', email: 'my_email@email.com', comment: 'My suggestion!', latitude: 40.4167754, longitude: -3.7037901999999576})
    @suggestion1.save
    @suggestion2 = Suggestion.create({category: Suggestion.category[:complaint], title: 'Complaint', author: 'Anonymous', email: 'my_email@email.com', comment: 'My complaint!', latitude: 40.3963198127118, longitude: -3.716254234313965})
    @suggestion2.save
  end

  context "search_filter" do
    it "should filter by category" do
      suggestion = Suggestion.search_filter(Suggestion.category[:suggestion], nil, nil, nil)
      expect(suggestion.first).to eq(@suggestion1)
    end

    it "should filter by title" do
      suggestion = Suggestion.search_filter(nil, 'Suggestion', nil, nil)
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
