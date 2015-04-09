require 'rails_helper'

RSpec.describe "Comment Builder tests: " do
  let (:builder) { CommentBuilder.new }
  before do
    @suggestion = Suggestion.create(title: 'Awesome Suggestion', author: 'Mister Fantastic', email: 'ReedRichards@email.com', comment: 'Lorem ipsum dolor sit amet', visible: true)
  end

  context "As a neighbor I want to" do
    context "comment a suggestion" do
      context "if my email is in whitelist" do
        before do
          WhiteListEmail.new(email: 'SusanStorm@email.com').save
          WhiteListEmail.new(email: 'JohnnyStorm@email.com').save
          builder.create({author: 'Human Torch', email: 'JohnnyStorm@email.com', text: 'Lorem ipsum'}, @suggestion, 'support suggestion')
        end

        it "should publish the comment" do
          comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor'}

          comment = builder.create(comment_params, @suggestion, nil)

          expect(comment.author).to eq('Invisible Woman')
          expect(comment.visible).to equal(true)
        end

        it "should send a email informing the other supporters about the new comment" do
          message_delivery = double(ActionMailer::MessageDelivery)
          comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor'}

          expect(SupporterMailer).to receive(:info_new_comment).with(@suggestion, an_instance_of(Comment), 'JohnnyStorm@email.com').and_return(message_delivery)
          expect(message_delivery).to receive(:deliver_later)

          builder.create(comment_params, @suggestion, nil)
        end
      end

      context "if my email is not in whitelist" do
        it "should send a email validation" do
          message_delivery = double(ActionMailer::MessageDelivery)
          comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor'}

          expect(CommentMailer).to receive(:comment_validation_email).with(an_instance_of(Comment)).and_return(message_delivery)
          expect(message_delivery).to receive(:deliver_later)

          comment = builder.create(comment_params, @suggestion, nil)

          expect(comment.author).to eq('Invisible Woman')
          expect(comment.visible).to equal(false)
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
            builder.create(comment_params, @suggestion, 'support suggestion')
          end

          it "should raise an exceptio" do
            comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'In maximus dolor et urna convallis, a porta tellus ullamcorper.'}

            expect { builder.create(comment_params, @suggestion, 'support suggestion') }.to raise_error CommentBuilder::OnlyOneSupportPerPersonIsAllowed
          end
        end

        context "and I have not yet supported the suggestion" do
          it "should publish the comment" do
            comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor'}

            comment = builder.create(comment_params, @suggestion, 'support suggestion')

            expect(comment.author).to eq('Invisible Woman')
            expect(comment.support).to equal(true)
            expect(comment.visible).to equal(true)
          end

          it "should inform me about the implications of supporting the suggestion" do
            message_delivery = double(ActionMailer::MessageDelivery)
            comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor'}

            expect(SupporterMailer).to receive(:info_for_supporters).with(an_instance_of(Comment)).and_return(message_delivery)
            expect(message_delivery).to receive(:deliver_later)

            builder.create(comment_params, @suggestion, 'support suggestion')
          end

          before do
            WhiteListEmail.new(email: 'JohnnyStorm@email.com').save
            builder.create({author: 'Human Torch', email: 'JohnnyStorm@email.com', text: 'Lorem ipsum'}, @suggestion, 'support suggestion')
          end
          it "should send a email informing the other supporters about the new comment" do
            message_delivery = double(ActionMailer::MessageDelivery)
            comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor'}

            expect(SupporterMailer).to receive(:info_new_comment).with(@suggestion, an_instance_of(Comment), 'JohnnyStorm@email.com').and_return(message_delivery)
            expect(message_delivery).to receive(:deliver_later)

            builder.create(comment_params, @suggestion, 'support suggestion')
          end
        end
      end

      context "if my email is not in whitelist" do
        it "should send a email validation" do
          message_delivery = double(ActionMailer::MessageDelivery)
          comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor'}

          expect(CommentMailer).to receive(:comment_validation_email).with(an_instance_of(Comment)).and_return(message_delivery)
          expect(message_delivery).to receive(:deliver_later)

          comment = builder.create(comment_params, @suggestion, 'support suggestion')

          expect(comment.author).to eq('Invisible Woman')
          expect(comment.visible).to equal(false)
        end
      end
    end
  end

  context "As a city council staff I want to" do
    before do
      CityCouncilDomain.new(domain: 'city_council.gov').save
    end

    context "comment a suggestion" do
      it 'sends an email to the author' do
        message_delivery = double(ActionMailer::MessageDelivery)
        comment_params = {author: 'The Thing', email: 'BenjaminGrimm@city_council.gov', text: 'In maximus dolor et urna convallis, a porta tellus ullamcorper.'}

        expect(CommentMailer).to receive(:city_council_staff_comment_validation).with(an_instance_of(Comment)).and_return(message_delivery)
        expect(message_delivery).to receive(:deliver_later)

        builder.create(comment_params, @suggestion, nil)
      end

      it "should publish the suggestion" do
        comment_params = {author: 'The Thing', email: 'BenjaminGrimm@city_council.gov', text: 'In maximus dolor et urna convallis, a porta tellus ullamcorper.'}

        comment = builder.create(comment_params, @suggestion, nil)

        expect(comment.author).to eq('The Thing')
        expect(comment.city_council_staff).to equal(true)
      end
    end

    context "if comments contains error" do
      it "should raise an exception" do
        comment_params = {email: 'BenjaminGrimm@city_council.gov'}

        expect { builder.create(comment_params, @suggestion, nil) }.to raise_error CommentBuilder::ErrorSavingComment
      end
    end

    context "support a suggestion" do
      it "should raise an exception" do
        comment_params = {author: 'The Thing', email: 'BenjaminGrimm@city_council.gov', text: 'In maximus dolor et urna convallis, a porta tellus ullamcorper.'}

        expect { builder.create(comment_params, @suggestion, 'support suggestion') }.to raise_error CommentBuilder::CityCouncilCannotSupport
      end
    end
  end
  
end
