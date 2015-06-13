class CityCouncilComment
  class CityCouncilCannotSupport < StandardError; end
  def initialize(suggestion, want_support, comment_attr)
    @want_support = want_support
    @suggestion = suggestion
    @comment_attr = comment_attr

  end
  def create
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

  private

  def send_city_council_staff_comment_validation_email
    CommentMailer.city_council_staff_comment_validation(@comment).deliver_later
  end
end
