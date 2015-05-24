class CommentBuilder
  class CityCouncilCannotSupport < StandardError; end
  class OnlyOneSupportPerPersonIsAllowed < StandardError; end
  class SuggestionClosed < StandardError; end
  class ErrorSavingComment < StandardError
    attr :comment
    def initialize(comment)
      @comment = comment
    end
  end

  def create(comment_params, suggestion, want_support)
    @comment_attr = comment_params
    @suggestion = suggestion
    @want_support = want_support
    if CityCouncilDomain.is_city_council_staff?(@comment_attr[:email])
      create_city_council_staff_comment
    else
      raise SuggestionClosed if @suggestion.closed?
      create_comment
    end
  end

  private

  def create_city_council_staff_comment
    raise CityCouncilCannotSupport if @want_support

    @comment_attr[:vote] = Comment.vote[:abstention]
    @comment_attr.merge!({city_council_staff: true, token_validation: ApplicationController.token_generator(10)})
    @comment = @suggestion.comments.create(@comment_attr)
    if @comment.save
      send_city_council_staff_comment_validation_email
      return @comment
    else
      raise ErrorSavingComment.new(@comment)
    end
  end

  def create_comment
    if @want_support
      raise OnlyOneSupportPerPersonIsAllowed if @suggestion.email_has_supported_me?(@comment_attr[:email])
      @comment_attr[:vote] = Comment.vote[:in_favour]
      @comment_attr.merge!({support: true})
    end

    @comment_attr.merge!({token_validation: ApplicationController.token_generator(10)})
    @comment = @suggestion.comments.create(@comment_attr)
    if @comment.save
      if WhiteListEmail.not_in_whitelist?(@comment.email)
        comment_validation_email
      else
        send_info_for_supporters_email
        send_info_email_to_supporters(@suggestion)
        @comment.update(visible: true)
      end
      return @comment
    else
      raise ErrorSavingComment.new(@comment)
    end
  end

  def comment_validation_email
    CommentMailer.comment_validation_email(@comment).deliver_later
  end

  def send_city_council_staff_comment_validation_email
    CommentMailer.city_council_staff_comment_validation(@comment).deliver_later
  end

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
end
