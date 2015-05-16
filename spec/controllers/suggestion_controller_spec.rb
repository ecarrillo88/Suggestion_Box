require 'rails_helper'

RSpec.describe SuggestionsController, type: :controller do

  before(:each) do
    @suggestion = Suggestion.create({category: 1, title: 'New title', author: 'Anonymous', email: 'my_email@email.com', comment: 'New comment', latitude: nil, longitude: nil})
    @suggestion.save
  end

  context "edit_request" do
    it "should show a flash message" do
      get :edit_request, :id => @suggestion.id
      expect(response).to redirect_to(@suggestion)
      expect(flash[:info]).to be_present
    end

    it "should send a email validation" do
      message_delivery = double(ActionMailer::MessageDelivery)
      expect(SuggestionMailer).to receive(:edit_suggestion_email_validation)
                              .with(an_instance_of(Suggestion))
                              .and_return(message_delivery)
      expect(message_delivery).to receive(:deliver_later)

      get :edit_request, :id => @suggestion.id
    end
  end
end
