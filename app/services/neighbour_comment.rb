class NeighbourComment
  class OnlyOneSupportPerPersonIsAllowed < StandardError; end
  class SuggestionClosed < StandardError; end

  def initialize(comment_input)
    raise SuggestionClosed if comment_input.suggestion.closed?
    @comment_input = comment_input
  end

  def create
    if @comment_input.supports
      raise OnlyOneSupportPerPersonIsAllowed if @comment_input.suggestion.email_has_supported_me?(@comment_input.fields[:email])
      @comment_input.fields[:vote] = Comment::IN_FAVOUR
      @comment_input.fields.merge!({support: true})
    end

    @comment_input.fields.merge!({token_validation: ApplicationController.token_generator(10)})
    @comment = @comment_input.suggestion.comments.create(@comment_input.fields)
    if @comment.save
      if WhiteListEmail.not_in_whitelist?(@comment.email)
        comment_validation_email
      else
        send_info_for_supporters_email
        send_info_email_to_supporters(@comment_input.suggestion)
        @comment.update(visible: true)
      end
    end
    @comment
  end

  private

  def send_info_for_supporters_email
    SupporterMailer.info_for_supporters(@comment).deliver_later if @comment.support
  end

  def send_info_email_to_supporters(suggestion)
    email_set = Set.new
    suggestion.comments.each do |comment|
      email_set.add(comment.email) if comment.support
    end
    email_set.delete(@comment.email)
    email_set.each do |email|
      SupporterMailer.info_new_comment(suggestion, @comment, email).deliver_later
    end
  end
  def comment_validation_email
    CommentMailer.comment_validation_email(@comment).deliver_later
  end
end
