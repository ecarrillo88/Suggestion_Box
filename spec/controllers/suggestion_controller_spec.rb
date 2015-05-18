require 'rails_helper'

RSpec.describe SuggestionsController, type: :controller do

  before(:each) do
    @suggestion = Suggestion.create({category: 1, title: 'New title', author: 'Anonymous', email: 'my_email@email.com', comment: 'New comment', latitude: nil, longitude: nil})
    @suggestion.save
  end

  context "edit" do
    it "should show a flash message" do
      get :edit, :id => @suggestion.id
      expect(response).to redirect_to(@suggestion)
      expect(flash[:info]).to be_present
    end

    it "should send a email validation" do
      message_delivery = double(ActionMailer::MessageDelivery)
      expect(SuggestionMailer).to receive(:edit_suggestion_email_validation)
                              .with(an_instance_of(Suggestion))
                              .and_return(message_delivery)
      expect(message_delivery).to receive(:deliver_later)

      get :edit, :id => @suggestion.id
    end
  end

  context "destroy" do
    it "should send a delete suggestion email validation" do
      message_delivery = double(ActionMailer::MessageDelivery)
      expect(SuggestionMailer).to receive(:delete_suggestion_email_validation)
                              .with(an_instance_of(Suggestion))
                              .and_return(message_delivery)
      expect(message_delivery).to receive(:deliver_later)

      delete :destroy, :id => @suggestion.slug, :token => nil
    end

    it "should destroy the suggestion" do
      @suggestion.update(token_validation: 'token')
      delete :destroy, :id => @suggestion.slug, :token => 'token'
      expect(Suggestion.exists?(@suggestion.slug)).to eq(false)
    end

    it "should not destroy the suggestion" do
      @suggestion.update(token_validation: 'token')
      delete :destroy, :id => @suggestion.slug,
                       :token => 'fake'
      expect(Suggestion.exists?(@suggestion.slug)).to eq(true)
    end
  end
end
