require 'rails_helper'

RSpec.describe "Comment Builder tests: " do
  let (:builder) { CommentBuilder.new }
  before do
    @suggestion_open = Suggestion.create(category: 1, title: 'Awesome Suggestion', author: 'Mister Fantastic', email: 'ReedRichards@email.com', comment: 'Lorem ipsum dolor sit amet', visible: true, closed: false)
    @suggestion_closed = Suggestion.create(category: 1, title: 'Suggestion Closed', author: 'Mister Fantastic', email: 'ReedRichards@email.com', comment: 'Lorem ipsum dolor sit amet', visible: true, closed: true)
  end

  context "As a neighbor I want to" do
    context "comment a suggestion when is open" do
      context "my email is in whitelist" do
        before do
          WhiteListEmail.new(email: 'SusanStorm@email.com').save
          WhiteListEmail.new(email: 'JohnnyStorm@email.com').save
          builder.create({author: 'Human Torch', email: 'JohnnyStorm@email.com', text: 'Lorem ipsum'}, @suggestion_open, true)
        end

        it "should publish the comment" do
          comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor', vote: Comment.vote[:abstention]}

          comment = builder.create(comment_params, @suggestion_open, false)

          expect(comment.author).to eq('Invisible Woman')
          expect(comment.visible?).to equal(true)
        end

        it "should send a email informing the other supporters about the new comment" do
          message_delivery = double(ActionMailer::MessageDelivery)
          comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor', vote: Comment.vote[:abstention]}

          expect(SupporterMailer).to receive(:info_new_comment).with(@suggestion_open, an_instance_of(Comment), 'JohnnyStorm@email.com').and_return(message_delivery)
          expect(message_delivery).to receive(:deliver_later)

          builder.create(comment_params, @suggestion_open, false)
        end

        context "I vote in favour" do
          it "should publish the comment as in favour" do
            comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor', vote: Comment.vote[:in_favour]}

            comment = builder.create(comment_params, @suggestion_open, false)

            expect(comment.author).to eq('Invisible Woman')
            expect(comment.visible?).to equal(true)
            expect(comment.vote).to equal(Comment.vote[:in_favour])
          end
        end

        context "I vote abstention" do
          it "should publish the comment as abstention" do
            comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor', vote: Comment.vote[:abstention]}

            comment = builder.create(comment_params, @suggestion_open, false)

            expect(comment.author).to eq('Invisible Woman')
            expect(comment.visible?).to equal(true)
            expect(comment.vote).to equal(Comment.vote[:abstention])
          end
        end

        context "I vote against" do
          it "should publish the comment as against" do
            comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor', vote: Comment.vote[:against]}

            comment = builder.create(comment_params, @suggestion_open, false)

            expect(comment.author).to eq('Invisible Woman')
            expect(comment.visible?).to equal(true)
            expect(comment.vote).to equal(Comment.vote[:against])
          end
        end
      end

      context "my email is not in whitelist" do
        it "should send a email validation" do
          message_delivery = double(ActionMailer::MessageDelivery)
          comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor', vote: Comment.vote[:abstention]}

          expect(CommentMailer).to receive(:comment_validation_email).with(an_instance_of(Comment)).and_return(message_delivery)
          expect(message_delivery).to receive(:deliver_later)

          comment = builder.create(comment_params, @suggestion_open, false)

          expect(comment.author).to eq('Invisible Woman')
          expect(comment.visible?).to equal(false)
        end
      end
    end

    context "comment a suggestion when is closed" do
      it "should raise an exception" do
        comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor', vote: Comment.vote[:abstention]}

        expect { builder.create(comment_params, @suggestion_closed, false) }.to raise_error NeighbourComment::SuggestionClosed
      end
    end

    context "support a suggestion when is open" do
      context "my email is in whitelist" do
        before do
          WhiteListEmail.new(email: 'SusanStorm@email.com').save
        end
        context "I have already supported the suggestion" do
          before do
            comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor', vote: Comment.vote[:abstention]}
            builder.create(comment_params, @suggestion_open, true)
          end

          it "should raise an exception" do
            comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'In maximus dolor et urna convallis, a porta tellus ullamcorper.', vote: Comment.vote[:abstention]}

            expect { builder.create(comment_params, @suggestion_open, true) }.to raise_error NeighbourComment::OnlyOneSupportPerPersonIsAllowed
          end
        end

        context "I have not yet supported the suggestion" do
          it "should publish the comment" do
            comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor', vote: Comment.vote[:abstention]}

            comment = builder.create(comment_params, @suggestion_open, true)

            expect(comment.author).to eq('Invisible Woman')
            expect(comment.support).to equal(true)
            expect(comment.visible?).to equal(true)
          end

          it "should inform me about the implications of supporting the suggestion" do
            message_delivery = double(ActionMailer::MessageDelivery)
            comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor', vote: Comment.vote[:abstention]}

            expect(SupporterMailer).to receive(:info_for_supporters).with(an_instance_of(Comment)).and_return(message_delivery)
            expect(message_delivery).to receive(:deliver_later)

            builder.create(comment_params, @suggestion_open, true)
          end

          before do
            WhiteListEmail.new(email: 'JohnnyStorm@email.com').save
            builder.create({author: 'Human Torch', email: 'JohnnyStorm@email.com', text: 'Lorem ipsum', vote: Comment.vote[:abstention]}, @suggestion_open, true)
          end
          it "should send a email informing the other supporters about the new comment" do
            message_delivery = double(ActionMailer::MessageDelivery)
            comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor', vote: Comment.vote[:abstention]}

            expect(SupporterMailer).to receive(:info_new_comment).with(@suggestion_open, an_instance_of(Comment), 'JohnnyStorm@email.com').and_return(message_delivery)
            expect(message_delivery).to receive(:deliver_later)

            builder.create(comment_params, @suggestion_open, true)
          end

          context "I vote in favour" do
            it "should publish the comment as in favour" do
              comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor', vote: Comment.vote[:in_favour]}

              comment = builder.create(comment_params, @suggestion_open, true)

              expect(comment.author).to eq('Invisible Woman')
              expect(comment.support).to equal(true)
              expect(comment.visible?).to equal(true)
              expect(comment.vote).to equal(Comment.vote[:in_favour])
            end
          end

          context "I vote abstention" do
            it "should publish the comment as in favour" do
              comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor', vote: Comment.vote[:abstention]}

              comment = builder.create(comment_params, @suggestion_open, true)

              expect(comment.author).to eq('Invisible Woman')
              expect(comment.support).to equal(true)
              expect(comment.visible?).to equal(true)
              expect(comment.vote).to equal(Comment.vote[:in_favour])
            end
          end

          context "I vote against" do
            it "should publish the comment as in favour" do
              comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor', vote: Comment.vote[:against]}

              comment = builder.create(comment_params, @suggestion_open, true)

              expect(comment.author).to eq('Invisible Woman')
              expect(comment.support).to equal(true)
              expect(comment.visible?).to equal(true)
              expect(comment.vote).to equal(Comment.vote[:in_favour])
            end
          end
        end
      end

      context "my email is not in whitelist" do
        it "should send a email validation" do
          message_delivery = double(ActionMailer::MessageDelivery)
          comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor', vote: Comment.vote[:abstention]}

          expect(CommentMailer).to receive(:comment_validation_email).with(an_instance_of(Comment)).and_return(message_delivery)
          expect(message_delivery).to receive(:deliver_later)

          comment = builder.create(comment_params, @suggestion_open, true)

          expect(comment.author).to eq('Invisible Woman')
          expect(comment.visible?).to equal(false)
        end
      end
    end

    context "support a suggestion when is closed" do
      it "should raise an exception" do
        comment_params = {author: 'Invisible Woman', email: 'SusanStorm@email.com', text: 'Aenean commodo ligula eget dolor', vote: Comment.vote[:abstention]}

        expect { builder.create(comment_params, @suggestion_closed, true) }.to raise_error NeighbourComment::SuggestionClosed
      end
    end
  end

  context "As a city council staff I want to" do
    before do
      CityCouncilDomain.new(domain: 'city_council.gov').save
    end

    context "comment a suggestion when is open" do
      it 'should sends an email to the author' do
        message_delivery = double(ActionMailer::MessageDelivery)
        comment_params = {author: 'The Thing', email: 'BenjaminGrimm@city_council.gov', text: 'In maximus dolor et urna convallis, a porta tellus ullamcorper.', vote: Comment.vote[:abstention]}

        expect(CommentMailer).to receive(:city_council_staff_comment_validation).with(an_instance_of(Comment)).and_return(message_delivery)
        expect(message_delivery).to receive(:deliver_later)

        builder.create(comment_params, @suggestion_open, false)
      end

      it "should publish the comment" do
        comment_params = {author: 'The Thing', email: 'BenjaminGrimm@city_council.gov', text: 'In maximus dolor et urna convallis, a porta tellus ullamcorper.', vote: Comment.vote[:abstention]}

        comment = builder.create(comment_params, @suggestion_open, false)

        expect(comment.author).to eq('The Thing')
        expect(comment.is_a_city_council_staff_comment?).to equal(true)
      end

      context "I vote in favour" do
        it "should publish the comment as abstencion" do
          comment_params = {author: 'The Thing', email: 'BenjaminGrimm@city_council.gov', text: 'In maximus dolor et urna convallis, a porta tellus ullamcorper.', vote: Comment.vote[:in_favour]}

          comment = builder.create(comment_params, @suggestion_open, false)

          expect(comment.author).to eq('The Thing')
          expect(comment.is_a_city_council_staff_comment?).to equal(true)
          expect(comment.vote).to equal(Comment.vote[:abstention])
        end
      end

      context "I vote abstention" do
        it "should publish the comment as abstencion" do
          comment_params = {author: 'The Thing', email: 'BenjaminGrimm@city_council.gov', text: 'In maximus dolor et urna convallis, a porta tellus ullamcorper.', vote: Comment.vote[:abstention]}

          comment = builder.create(comment_params, @suggestion_open, false)

          expect(comment.author).to eq('The Thing')
          expect(comment.is_a_city_council_staff_comment?).to equal(true)
          expect(comment.vote).to equal(Comment.vote[:abstention])
        end
      end

      context "I vote against" do
        it "should publish the comment as abstencion" do
          comment_params = {author: 'The Thing', email: 'BenjaminGrimm@city_council.gov', text: 'In maximus dolor et urna convallis, a porta tellus ullamcorper.', vote: Comment.vote[:against]}

          comment = builder.create(comment_params, @suggestion_open, false)

          expect(comment.author).to eq('The Thing')
          expect(comment.is_a_city_council_staff_comment?).to equal(true)
          expect(comment.vote).to equal(Comment.vote[:abstention])
        end
      end
    end

    context "comment a suggestion when is closed" do
      it "should publish the comment" do
        comment_params = {author: 'The Thing', email: 'BenjaminGrimm@city_council.gov', text: 'In maximus dolor et urna convallis, a porta tellus ullamcorper.', vote: Comment.vote[:abstention]}

        comment = builder.create(comment_params, @suggestion_closed, false)

        expect(comment.author).to eq('The Thing')
        expect(comment.is_a_city_council_staff_comment?).to equal(true)
      end
    end

    context "support a suggestion" do
      it "should raise an exception" do
        comment_params = {author: 'The Thing', email: 'BenjaminGrimm@city_council.gov', text: 'In maximus dolor et urna convallis, a porta tellus ullamcorper.', vote: Comment.vote[:abstention]}

        expect { builder.create(comment_params, @suggestion_open, true) }.to raise_error CityCouncilComment::CityCouncilCannotSupport
      end
    end
  end

  context "when a comment is created without the required fields" do
    it "should raise an exception" do
      comment_params = {author: "", email: "", text: "", vote: Comment.vote[:abstention]}

      expect { builder.create(comment_params, @suggestion_open, false) }.to raise_error CommentBuilder::ErrorSavingComment
    end
  end
end
