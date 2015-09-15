require 'rails_helper'

RSpec.describe Suggestion, type: :model do


  context 'A suggestion without author' do
    it 'has error' do
    suggestion = Suggestion.create({category: Suggestion.category[:issue], title: 'Issue', author: nil, email: 'my_email@email.com', comment: 'An Issue', latitude: nil, longitude: nil, visible: true, closed: 1})

    suggestion.valid?

    expect(suggestion.errors.messages).to eql(author: ["An author name is required"])
    end

  end

  context "search_filter" do
  before(:each) do
    @suggestion1 = Suggestion.create({category: Suggestion.category[:suggestion], title: 'Suggestion of the year', author: 'Anonymous', email: 'my_email@email.com', comment: 'My suggestion!', latitude: nil, longitude: nil, visible: true, closed: 0})
    @suggestion2 = Suggestion.create({category: Suggestion.category[:complaint], title: 'Complaint', author: 'Anonymous', email: 'my_email@email.com', comment: 'My complaint!', latitude: nil, longitude: nil, visible: true, closed: 0})
    @suggestion3 = Suggestion.create({category: Suggestion.category[:suggestion], title: 'Suggestion', author: 'Anonymous', email: 'my_email@email.com', comment: 'Another suggestion', latitude: nil, longitude: nil, visible: true, closed: 0})
    @suggestion4 = Suggestion.create({category: Suggestion.category[:issue], title: 'Issue', author: 'Anonymous', email: 'my_email@email.com', comment: 'An Issue', latitude: nil, longitude: nil, visible: true, closed: 1})
  end
    it "should show all suggestions" do
      title = nil
      category = nil
      status = nil
      address = nil
      distance = nil
      suggestions = Suggestion.search_filter(title, category, status, address, distance)
      expect(suggestions).to eq([@suggestion4, @suggestion3, @suggestion2, @suggestion1])
    end

    it "should filter by category" do
      suggestion = Suggestion.search_filter(nil, Suggestion.category[:complaint], nil, nil, nil)
      expect(suggestion).to eq([@suggestion2])
    end

    it "should filter by title" do
      suggestion = Suggestion.search_filter('Suggestion', nil, nil, nil, nil)
      expect(suggestion).to eq([@suggestion3, @suggestion1])
    end

    it "should filter by title with multiple words" do
      suggestion = Suggestion.search_filter('Suggestion of the year', nil, nil, nil, nil)
      expect(suggestion).to eq([@suggestion1])
    end


    it "should show open suggestions" do
      suggestion = Suggestion.search_filter(nil, nil, 0, nil, nil)
      expect(suggestion).to eq([@suggestion3, @suggestion2, @suggestion1])
    end

    it "should show closed suggestions" do
      suggestion = Suggestion.search_filter(nil, nil, 1, nil, nil)
      expect(suggestion).to eq([@suggestion4])
    end
  end
end
