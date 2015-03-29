class CommentMailer < ApplicationMailer
  default from: 'no-reply@suggestion-box.com'
 
  def comment_validation_email(comment)
    @comment = comment
    @url  = get_host + "comment/validation/#{Base64.encode64(@comment.email)}/"
    mail(to: @comment.email, subject: 'Suggestion Box - Comment validation')
  end
  
  def city_council_staff_comment_validation(comment)
    @comment = comment
    @url  = get_host + "comment/validation/#{Base64.encode64(@comment.email)}/"
    mail(to: @comment.email, subject: 'Suggestion Box - Comment validation')
  end
  
  private
  
  def get_host
    if Rails.env == "production"
      return "https://tfg-suggestion-box.herokuapp.com/"
    else
      return "http://localhost:3000/"
    end
  end
end
