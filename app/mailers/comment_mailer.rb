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

  def report_comment(comment, responsible_person)
    @comment = comment
    @responsible_person = responsible_person
    @url  = get_host + "suggestions/#{@comment.suggestion.slug}/"
    mail(to: @responsible_person.email, subject: 'Suggestion Box - Comment reported')
  end
end
