require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  before(:each) do
    @suggestion = Suggestion.create({category: 1, title: 'New title', author: 'Anonymous', email: 'my_email@email.com', comment: 'My suggestion!', latitude: nil, longitude: nil})
    @suggestion.save
    @comment = @suggestion.comments.create({author: 'Spider-Man', text: 'I am Amazing!', email: 'PeterParker@spider.net', vote: Comment::IN_FAVOUR})
    @comment.save
  end

  context "destroy" do
    it "should send a delete comment email validation" do
      message_delivery = double(ActionMailer::MessageDelivery)
      expect(CommentMailer).to receive(:delete_comment_email_validation)
                              .with(an_instance_of(Comment))
                              .and_return(message_delivery)
      expect(message_delivery).to receive(:deliver_later)

      delete :destroy, :suggestion_id => @suggestion.id,
                       :id => @comment.id,
                       :token => nil
    end

    it "should destroy the comment" do
      @comment.update(token_validation: 'token')
      delete :destroy, :suggestion_id => @suggestion.id,
                       :id => @comment.id,
                       :token => 'token'
      expect(@suggestion.comments.last).to eq(nil)
    end

    it "should not destroy the comment" do
      @comment.update(token_validation: 'token')
      delete :destroy, :suggestion_id => @suggestion.id,
                       :id => @comment.id,
                       :token => 'fake'
      expect(@suggestion.comments.last).to eq(@comment)
    end
  end
end
