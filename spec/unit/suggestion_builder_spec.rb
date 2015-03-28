require 'rails_helper'

RSpec.describe "Suggestion Builder tests" do  
  it "should upload an image" do
    image_manager = double("Image Manager")
    builder = SuggestionBuilder.new(image_manager)
    suggestion_params = {title: 'New title', author: 'Anonymous', email: 'my_email@email.com', comment: 'New comment', latitude: nil, longitude: nil}
    
    expect(image_manager).to receive(:upload_image).with('image').and_return({public_id: :public_id})
    
    builder.create(suggestion_params, 'image', nil)
  end
  
  it "should fail to create a suggestion without title" do
    builder = SuggestionBuilder.new
    suggestion_params = {title: nil, author: 'Anonymous', email: 'my_email@email.com', comment: 'New comment', latitude: nil, longitude: nil}
    
    suggestion_hash = builder.create(suggestion_params, nil, nil)
    
    expect(suggestion_hash[:save]).to equal(false)
  end
  
  context "email in whielist" do
    before(:each) do
      WhiteListEmail.new(email: 'email_validated@email.com').save
    end
    
    it "should publish the suggestion" do
      builder = SuggestionBuilder.new
      suggestion_params = {title: 'New title', author: 'Anonymous', email: 'email_validated@email.com', comment: 'New comment', latitude: nil, longitude: nil}
      
      suggestion_hash = builder.create(suggestion_params, nil, nil)
      
      expect(suggestion_hash[:save]).to equal(true)
      expect(suggestion_hash[:suggestion].visible).to equal(true)
      expect(suggestion_hash[:msg]) == I18n.t('suggestions.create.flash_create_ok')
    end
  end
  
  context "email not in whitelist" do
    it "should save the suggestion and not make it visible" do
      builder = SuggestionBuilder.new
      suggestion_params = {title: 'New title', author: 'Anonymous', email: 'email_validated@email.com', comment: 'New comment', latitude: nil, longitude: nil}
      
      suggestion_hash = builder.create(suggestion_params, nil, nil)
      
      expect(suggestion_hash[:save]).to equal(true)
      expect(suggestion_hash[:suggestion].visible).to equal(false)
    end
    
    it "should send a validation email" do
      message_delivery = double(ActionMailer::MessageDelivery)
      builder = SuggestionBuilder.new
      suggestion_params = {title: 'New title', author: 'Anonymous', email: 'email_validated@email.com', comment: 'New comment', latitude: nil, longitude: nil}
      
      expect(SuggestionMailer).to receive(:suggestion_validation_email).with(an_instance_of(Suggestion)).and_return(message_delivery)
      expect(message_delivery).to receive(:deliver_later)
      
      suggestion_hash =  builder.create(suggestion_params, nil, nil)
    end
    
    it "should dislplay a message informing the validation email has been sent" do
      builder = SuggestionBuilder.new
      suggestion_params = {title: 'New title', author: 'Anonymous', email: 'email_validated@email.com', comment: 'New comment', latitude: nil, longitude: nil}
      
      suggestion_hash =  builder.create(suggestion_params, nil, nil)
      
      expect(suggestion_hash[:msg]) == (I18n.t('suggestions.create.flash_email_info'))
    end
  end
end
