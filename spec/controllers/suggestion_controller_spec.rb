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

  context "GET edit" do
    context "if the token parameter is not present" do
      it "should show a flash message" do
        get :edit, id: @suggestion.id, token: nil
        expect(response).to redirect_to(@suggestion)
        expect(flash[:info]).to eq(I18n.t('suggestions.edit.flash_email_info'))
      end

      it "should send a email validation" do
        message_delivery = double(ActionMailer::MessageDelivery)
        expect(SuggestionMailer).to receive(:edit_suggestion_email_validation)
                                .with(an_instance_of(Suggestion))
                                .and_return(message_delivery)
        expect(message_delivery).to receive(:deliver_later)

        get :edit, id: @suggestion.id, token: nil
      end
    end

    context "if the token parameter is valid" do
      it "should render suggestion edit page" do
        @suggestion.update(token_validation: 'token_OK')
        get :edit, id: @suggestion.id, token: 'token_OK'

        expect(response).to render_template(:edit)
      end
    end

    context "if the token parameter is invalid" do
      it "should show a flash error message" do
        @suggestion.update(token_validation: 'token_OK')
        get :edit, id: @suggestion.id, token: 'token_KO'

        expect(flash[:danger]).to eq(I18n.t('suggestions.edit.flash_edit_token_error'))
      end

      it "should redirect to suggestion" do
        @suggestion.update(token_validation: 'token_OK')
        get :edit, id: @suggestion.id, token: 'token_KO'

        expect(response).to redirect_to(@suggestion)
      end
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

  context "PATCH update" do
    context "If suggestion has been updated" do
      it "should show a flash message" do
        patch :update, id: @suggestion.id, suggestion: {category: 2, title: 'Updates title', author: 'Anonymous', email: 'anonymous@email.com', comment: 'New comment', latitude: nil, longitude: nil}

        expect(flash[:info]).to eq(I18n.t('suggestions.update.flash_update_ok'))
      end

      it "should be success" do
        patch :update, id: @suggestion.id, suggestion: {category: nil, title: nil, author: nil, email: nil, comment: nil, latitude: nil, longitude: nil}

        expect(response).to be_success
      end
    end

    context "If suggestion has not been updated" do
      it "should render edit suggestion page" do
        patch :update, id: @suggestion.id, suggestion: {category: nil, title: nil, author: nil, email: nil, comment: nil, latitude: nil, longitude: nil}

        expect(response).to render_template(:edit)
      end
    end
  end

end
