require 'rails_helper'

RSpec.describe "Suggestion Builder tests" do
  before do
    WhiteListEmail.new(email: 'email_validated@email.com').save
  end
  
  it "should upload an image" do
    image_manager = double("Image Manager")
    builder = SuggestionBuilder.new(image_manager)
    suggestion_params = {title: 'titulo', author: 'autor', email: 'email_not_validated@email.com', comment: 'tdsfrg', latitude: nil, longitude: nil}
    
    expect(image_manager).to receive(:upload_image).with('img1').and_return({public_id: :aaaa})
    
    builder.create(suggestion_params, 'img1', nil)
  end
  
  it "should fail to create a suggestion without title" do
    image_manager = double("Image Manager")
    builder = SuggestionBuilder.new(image_manager)
    suggestion_params = {title: nil, author: 'autor', email: 'email_not_validated@email.com', comment: 'tdsfrg', latitude: nil, longitude: nil}
    
    allow(image_manager).to receive(:upload_image).with('img1').and_return({public_id: :aaaa})
    
    suggestion_hash = builder.create(suggestion_params, 'img1', nil)
    
    expect(suggestion_hash[:save]).to equal(false)
  end
  
  it "should publish the suggestion if the email is in whitelist" do
    image_manager = double("Image Manager")
    builder = SuggestionBuilder.new(image_manager)
    suggestion_params = {title: 'titulo', author: 'autor', email: 'email_validated@email.com', comment: 'tdsfrg', latitude: nil, longitude: nil}
    
    allow(image_manager).to receive(:upload_image).with('img1').and_return({public_id: :aaaa})
    
    suggestion_hash = builder.create(suggestion_params, 'img1', nil)
    
    expect(suggestion_hash[:save]).to equal(true)
    expect(suggestion_hash[:suggestion].visible).to equal(true)
    expect(suggestion_hash[:msg]) == I18n.t('suggestions.create.flash_create_ok')
  end
  
  it "should save the suggestion and not make it visible if the email is not in the whitelist" do
    image_manager = double("Image Manager")
    builder = SuggestionBuilder.new(image_manager)
    suggestion_params = {title: 'titulo', author: 'autor', email: 'email_not_validated@email.com', comment: 'tdsfrg', latitude: nil, longitude: nil}
    
    allow(image_manager).to receive(:upload_image).with('img1').and_return({public_id: :aaaa})
    
    suggestion_hash = builder.create(suggestion_params, 'img1', nil)
    
    expect(suggestion_hash[:save]).to equal(true)
    expect(suggestion_hash[:suggestion].visible).to equal(false)
  end
  
  it "should send a validation email if the email is not in the whitelist" do
    image_manager = double("Image Manager")
    builder = SuggestionBuilder.new(image_manager)
    suggestion_params = {title: 'titulo', author: 'autor', email: 'email_not_validated@email.com', comment: 'tdsfrg', latitude: nil, longitude: nil}
    
    allow(image_manager).to receive(:upload_image).with('img1').and_return({public_id: :aaaa})
    
    suggestion_hash =  builder.create(suggestion_params, 'img1', nil)
    
    expect(suggestion_hash[:msg]) == (I18n.t('suggestions.create.flash_email_info'))
  end
end
