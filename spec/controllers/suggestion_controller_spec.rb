require 'rails_helper'

RSpec.describe SuggestionsController, type: :controller do

  before(:each) do
    @suggestion = Suggestion.create({ category: 1, title: 'New title', author: 'Anonymous', email: 'my_email@email.com', comment: 'New comment', latitude: nil, longitude: nil })
    @suggestion.comments.create(author: 'Han Solo', email: 'MillenniumFalcon@email.com', text: 'In maximus dolor et urna convallis, a porta tellus ullamcorper.', visible: true, vote: Comment::ABSTENTION)
  end

  context "GET index" do
    it "should be success" do
      get :index, suggestion: @suggestion.slug
      expect(response).to be_success
    end
  end

  context "GET show" do
    it "should be success" do
      get :show, id: @suggestion.id
      expect(response).to be_success
    end
  end

  context "GET new" do
    it "should be success" do
      get :new
      expect(response).to be_success
    end
  end

  context "POST create" do
    context "If the suggestion is created" do
      it "should redirect to suggestion" do
        suggestion_params = {category: 1, title: 'New title 2', author: 'Anonymous', email: 'my_email@email.com', comment: 'New comment', latitude: nil, longitude: nil}
        post :create, suggestion: suggestion_params

        expect(response).to redirect_to("/es/suggestions/new-title-2")
      end
    end

    context "If the suggestion contains an error" do
      it "should render new" do
        post :create, suggestion: {category: nil, title: nil, author: nil, email: nil, comment: nil, latitude: nil, longitude: nil}

        expect(response).to render_template(:new)
      end
    end
  end
end
