class CommentMailer < ApplicationMailer

  def comment_validation_email(comment)
    @comment = comment
    @url  = get_host + "comment_validation/#{@comment.token_validation}/"
    mail(to: @comment.email, subject: 'Suggestion Box - New comment validation')
  end

  def city_council_staff_comment_validation(comment)
    @comment = comment
    @url  = get_host + "comment_validation/#{@comment.token_validation}/"
    mail(to: @comment.email, subject: 'Suggestion Box - Comment validation')
  end

  def delete_comment_email_validation(comment)
    @comment = comment
    @url  = get_host + "suggestions/#{@comment.suggestion.id}/comments/#{@comment.id}/#{@comment.token_validation}/"
    mail(to: @comment.email, subject: 'Suggestion Box - Delete comment confirmation')
  end
end
