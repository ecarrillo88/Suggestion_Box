class CommentMailer < ApplicationMailer
  default from: 'no-reply@suggestion-box.com'
 
  def comment_validation_email(comment)
    @comment = comment
    if Rails.env == "production"
      host = "https://tfg-suggestion-box.herokuapp.com/"
    else
      host  = "http://localhost:3000/"
    end
    @url  = host + "comment/validation/#{Base64.encode64(@comment.email)}/"
    mail(to: @comment.email, subject: 'Suggestion Box - Comment validation')
  end
end
