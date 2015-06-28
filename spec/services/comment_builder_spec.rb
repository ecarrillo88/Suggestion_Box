require 'rails_helper'

RSpec.describe CommentBuilder do
  let (:builder) { CommentBuilder.new }

  before do
    @suggestion_open = Suggestion.create(category: 1, title: 'Awesome Suggestion', author: 'Mister Fantastic', email: 'ReedRichards@email.com', comment: 'Lorem ipsum dolor sit amet', visible: true, closed: 0)
    @suggestion_closed = Suggestion.create(category: 1, title: 'Suggestion Closed', author: 'Mister Fantastic', email: 'ReedRichards@email.com', comment: 'Lorem ipsum dolor sit amet', visible: true, closed: 1)
  end
  let(:any_params) { {author: 'The Thing', email: 'thething@email.com', text: 'GRRRRRR', vote: Comment::IN_FAVOUR}}

  context "As a neighbor I want to" do
    context "comment a suggestion when it is open" do
      context "my email is in whitelist" do
        before do
          WhiteListEmail.create(email: 'SusanStorm@email.com')
          WhiteListEmail.create(email: 'JohnnyStorm@email.com')
        end


        it "should publish the comment" do
          comment_params = any_params.merge({ author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor' })

          comment = builder.create(comment_params, @suggestion_open, false)

          expect(comment.author).to eql('Invisible Woman')
          expect(comment.email).to eql('SusanStorm@email.com')
          expect(comment.text).to eql('Aenean commodo ligula eget dolor')
          expect(comment.visible?).to eql(true)
        end

        it "should send a email informing the other supporters about the new comment" do
          comment_params = any_params.merge(email: 'SusanStorm@email.com')
          builder.create({author: 'Human Torch', email: 'JohnnyStorm@email.com', text: 'Lorem ipsum'}, @suggestion_open, true)
          message_delivery = double(ActionMailer::MessageDelivery)

          expect(SupporterMailer).to receive(:info_new_comment).
            with(@suggestion_open, an_instance_of(Comment), 'JohnnyStorm@email.com').
            and_return(message_delivery)
          expect(message_delivery).to receive(:deliver_later)

          builder.create(comment_params, @suggestion_open, false)
        end

        context "I vote" do
          it "should publish the comment with my opinion" do
            comment_params = any_params.merge(vote: Comment::ABSTENTION)

            comment = builder.create(comment_params, @suggestion_open, false)

            expect(comment.vote).to equal(Comment::ABSTENTION)
          end
        end
      end

      context "my email is not in whitelist" do
        it "should send a email validation" do
          message_delivery = double(ActionMailer::MessageDelivery)

          expect(CommentMailer).to receive(:comment_validation_email)
            .with(an_instance_of(Comment))
            .and_return(message_delivery)
          expect(message_delivery).to receive(:deliver_later)

          builder.create(any_params, @suggestion_open, false)
        end
      end
    end

    context "comment a suggestion when is closed" do
      it "should raise an exception" do
        expect { builder.create(any_params, @suggestion_closed, false) }.to raise_error NeighbourComment::SuggestionClosed
      end
    end

    context "support a suggestion when is open" do
      context "my email is in whitelist" do
        let(:whitelisted_email) { 'SusanStorm@email.com' }

        before do
          WhiteListEmail.create(email: whitelisted_email)
        end

        context "I have already supported the suggestion" do
          it "should raise an exception" do
            comment_params = any_params.merge(email: whitelisted_email)
            builder.create(comment_params, @suggestion_open, true)

            expect { builder.create(comment_params, @suggestion_open, true) }.to raise_error NeighbourComment::OnlyOneSupportPerPersonIsAllowed
          end
        end

        context "I have not yet supported the suggestion" do
          it "should publish the comment" do
            comment_params = any_params.merge(email: whitelisted_email)

            comment = builder.create(comment_params, @suggestion_open, true)

            expect(comment.visible?).to equal(true)
          end

          it "should inform me about the implications of supporting the suggestion" do
            message_delivery = double(ActionMailer::MessageDelivery)
            comment_params = any_params.merge(email: whitelisted_email)

            expect(SupporterMailer).to receive(:info_for_supporters).
              with(an_instance_of(Comment)).
              and_return(message_delivery)
            expect(message_delivery).to receive(:deliver_later)

            builder.create(comment_params, @suggestion_open, true)
          end

          it "should send a email informing the other supporters about the new comment" do
            WhiteListEmail.new(email: 'JohnnyStorm@email.com').save
            builder.create(any_params.merge(email:  'JohnnyStorm@email.com'), @suggestion_open, true)
            message_delivery = double(ActionMailer::MessageDelivery)
            comment_params = any_params.merge(email: whitelisted_email)

            expect(SupporterMailer).to receive(:info_new_comment).
              with(@suggestion_open, an_instance_of(Comment), 'JohnnyStorm@email.com').
              and_return(message_delivery)
            expect(message_delivery).to receive(:deliver_later)

            builder.create(comment_params, @suggestion_open, true)
          end
        end
      end

      context "my email is not in whitelist" do
        it "should send a email validation" do
          message_delivery = double(ActionMailer::MessageDelivery)
          comment_params = any_params.merge(email:  'SusanStorm@email.com')

          expect(CommentMailer).to receive(:comment_validation_email).
            with(an_instance_of(Comment)).
            and_return(message_delivery)
          expect(message_delivery).to receive(:deliver_later)

          comment = builder.create(comment_params, @suggestion_open, true)

          expect(comment.visible?).to equal(false)
        end
      end
    end

    context "support a suggestion when is closed" do
      it "should raise an exception" do
        expect { builder.create(any_params, @suggestion_closed, true) }.to raise_error NeighbourComment::SuggestionClosed
      end
    end
  end

  context "As a city council staff I want to" do
    let(:any_params_of_council) { {author: 'The Thing', email:  'BenjaminGrimm@city_council.gov', text:  'In maximus dolor et urna convallis, a porta tellus ullamcorper.', vote: Comment::ABSTENTION}}

    before do
      CityCouncilDomain.create(domain: 'city_council.gov')
    end

    context "comment a suggestion when is open" do
      it 'should send an email to the author' do
        message_delivery = double(ActionMailer::MessageDelivery)

        expect(CommentMailer).to receive(:city_council_staff_comment_validation).
          with(an_instance_of(Comment)).
          and_return(message_delivery)
        expect(message_delivery).to receive(:deliver_later)

        builder.create(any_params_of_council, @suggestion_open, false)
      end

      it "should publish the comment" do
        comment = builder.create(any_params_of_council, @suggestion_open, false)

        expect(comment.author).to eq('The Thing')
        expect(comment.is_a_city_council_staff_comment?).to equal(true)
      end

      it "should publish the comment always as abstention" do
        comment_params = any_params_of_council.merge(vote: Comment::IN_FAVOUR)

        comment = builder.create(comment_params, @suggestion_open, false)

        expect(comment.vote).to equal(Comment::ABSTENTION)
      end
    end

    context "comment a suggestion when is closed" do
      it "should publish the comment" do
        comment = builder.create(any_params_of_council, @suggestion_closed, false)

        expect(comment.author).to eq('The Thing')
        expect(comment.is_a_city_council_staff_comment?).to equal(true)
      end
    end

    context "support a suggestion" do
      it "should raise an exception" do
        expect { builder.create(any_params_of_council, @suggestion_open, true) }.to raise_error CityCouncilComment::CityCouncilCannotSupport
      end
    end
  end

  context "when a comment is created without the required fields" do
    it "should raise an exception" do
      comment_params = {author: "", email: "", text: "", vote: Comment::IN_FAVOUR}

      expect { builder.create(comment_params, @suggestion_open, false) }.to raise_error CommentBuilder::ErrorSavingComment
    end
  end
end
