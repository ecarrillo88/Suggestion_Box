require 'rails_helper'

RSpec.describe "Comment Builder tests: " do
  before do
    @builder = CommentBuilder.new
    @suggestion = Suggestion.create(title: 'Awesome Suggestion', author: 'Mister Fantastic', email: 'ReedRichards@email.com', comment: 'Lorem ipsum dolor sit amet', visible: true)
  end
  
  context "As a neighbor I want to" do
    context "comment a suggestion" do
      context "if my email is in whitelist" do
        before do
          WhiteListEmail.new(email: 'SusanStorm@email.com').save
          WhiteListEmail.new(email: 'JohnnyStorm@email.com').save
          @builder.create({author: 'Human Torch', email: 'JohnnyStorm@email.com', text: 'Lorem ipsum'}, @suggestion, 'support suggestion')
        end
        
        it "should publish the comment" do
          comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor'}
          
          flash_type, flash_msg, action = @builder.create(comment_params, @suggestion, nil)
          
          expect(@suggestion.comments.last.author).to eq('Invisible Woman')
          expect(@suggestion.comments.last.visible).to equal(true)
          expect(I18n.t('comments.create'+flash_msg)).to eq(I18n.t('comments.create.flash_create_ok'))
        end
        
        it "should send a email informing the other supporters about the new comment" do
          message_delivery = double(ActionMailer::MessageDelivery)
          comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor'}
          
          expect(SupporterMailer).to receive(:info_new_comment).with(@suggestion, an_instance_of(Comment), 'JohnnyStorm@email.com').and_return(message_delivery)
          expect(message_delivery).to receive(:deliver_later)
          
          @builder.create(comment_params, @suggestion, nil)
        end
      end
      
      context "if my email is not in whitelist" do
        it "should send a validation email" do
          message_delivery = double(ActionMailer::MessageDelivery)
          comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor'}
          
          expect(CommentMailer).to receive(:comment_validation_email).with(an_instance_of(Comment)).and_return(message_delivery)
          expect(message_delivery).to receive(:deliver_later)
          
          flash_type, flash_msg, action = @builder.create(comment_params, @suggestion, nil)
          
          expect(@suggestion.comments.last.author).to eq('Invisible Woman')
          expect(@suggestion.comments.last.visible).to equal(false)
          expect(I18n.t('comments.create'+flash_msg)).to eq(I18n.t('comments.create.flash_email_info'))
        end
      end
    end
  
    context "support a suggestion" do
      context "if my email is in whitelist" do
        before do
          WhiteListEmail.new(email: 'SusanStorm@email.com').save
        end
        context "and I have already supported the suggestion" do
          before do
            comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor'}
            @builder.create(comment_params, @suggestion, 'support suggestion')
          end
          
          it "should display an error message" do
            comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'In maximus dolor et urna convallis, a porta tellus ullamcorper.'}
            
            flash_type, flash_msg, action = @builder.create(comment_params, @suggestion, 'support suggestion')
            
            expect(I18n.t('comments.create'+flash_msg)).to eq(I18n.t('comments.create.flash_support_error'))
          end
        end
        
        context "and I have not yet supported the suggestion" do
          it "should publish the comment" do
            comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor'}
            
            flash_type, flash_msg, action = @builder.create(comment_params, @suggestion, 'support suggestion')
            
            expect(@suggestion.comments.last.author).to eq('Invisible Woman')
            expect(@suggestion.comments.last.support).to equal(true)
            expect(@suggestion.comments.last.visible).to equal(true)
            expect(I18n.t('comments.create'+flash_msg)).to eq(I18n.t('comments.create.flash_create_ok'))
          end
          
          it "should inform me about the implications of supporting the suggestion" do
            message_delivery = double(ActionMailer::MessageDelivery)
            comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor'}
            
            expect(SupporterMailer).to receive(:info_for_supporters).with(an_instance_of(Comment)).and_return(message_delivery)
            expect(message_delivery).to receive(:deliver_later)
            
            @builder.create(comment_params, @suggestion, 'support suggestion')
          end
          
          before do
            WhiteListEmail.new(email: 'JohnnyStorm@email.com').save
            @builder.create({author: 'Human Torch', email: 'JohnnyStorm@email.com', text: 'Lorem ipsum'}, @suggestion, 'support suggestion')
          end
          it "should send a email informing the other supporters about the new comment" do
            message_delivery = double(ActionMailer::MessageDelivery)
            comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor'}
            
            expect(SupporterMailer).to receive(:info_new_comment).with(@suggestion, an_instance_of(Comment), 'JohnnyStorm@email.com').and_return(message_delivery)
            expect(message_delivery).to receive(:deliver_later)
            
            @builder.create(comment_params, @suggestion, 'support suggestion')
          end
        end
      end
      
      context "if my email is not in whitelist" do
        it "should send a validation email" do
          message_delivery = double(ActionMailer::MessageDelivery)
          comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor'}
          
          expect(CommentMailer).to receive(:comment_validation_email).with(an_instance_of(Comment)).and_return(message_delivery)
          expect(message_delivery).to receive(:deliver_later)
          
          flash_type, flash_msg, action = @builder.create(comment_params, @suggestion, 'support suggestion')
          
          expect(@suggestion.comments.last.author).to eq('Invisible Woman')
          expect(@suggestion.comments.last.visible).to equal(false)
          expect(I18n.t('comments.create'+flash_msg)).to eq(I18n.t('comments.create.flash_email_info'))
        end
      end
    end
  end
  
    context "As a city council staff I want to" do
      before do
        CityCouncilDomain.new(domain: 'city_council.gov').save
      end
      
      context "comment a suggestion" do
        it "should publish the suggestion" do
          message_delivery = double(ActionMailer::MessageDelivery)
          comment_params = {author: 'The Thing', email: 'BenjaminGrimm@city_council.gov', text: 'In maximus dolor et urna convallis, a porta tellus ullamcorper.'}
          
          expect(CommentMailer).to receive(:city_council_staff_comment_validation).with(an_instance_of(Comment)).and_return(message_delivery)
          expect(message_delivery).to receive(:deliver_later)
          
          flash_type, flash_msg, action = @builder.create(comment_params, @suggestion, nil)
          
          expect(@suggestion.comments.last.author).to eq('The Thing')
          expect(@suggestion.comments.last.city_council_staff).to equal(true)
          expect(I18n.t("comments.create"+flash_msg)).to eq(I18n.t('comments.create.flash_email_info'))
        end
      end
      
      context "support a suggestion" do
        it "should display an error message" do
          comment_params = {author: 'The Thing', email: 'BenjaminGrimm@city_council.gov', text: 'In maximus dolor et urna convallis, a porta tellus ullamcorper.'}
          
          flash_type, flash_msg, action = @builder.create(comment_params, @suggestion, 'support suggestion')
          
          expect(I18n.t("comments.create"+flash_msg)).to eq(I18n.t('comments.create.flash_city_council_staff_support_error'))
        end
      end
    end
end
