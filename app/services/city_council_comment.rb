class CityCouncilComment
  class CityCouncilCannotSupport < StandardError; end
  def initialize(comment_input)
    @comment_input = comment_input
  end

  def create
    raise CityCouncilCannotSupport if @comment_input.supports

    @comment_input.fields[:vote] = Comment.vote[:abstention]
    @comment_input.fields.merge!({city_council_staff: true, token_validation: ApplicationController.token_generator(10)})
    comment = @comment_input.suggestion.comments.create(@comment_input.fields)
    if comment.save
      send_city_council_staff_comment_validation_email(comment)
    end
    comment
  end

  private

  def send_city_council_staff_comment_validation_email(comment)
    CommentMailer.city_council_staff_comment_validation(comment).deliver_later
  end
end
