class SupporterMailer < ApplicationMailer
  default from: 'no-reply@suggestion-box.com'
 
  def info_new_comment(suggestion, comment, email)
    @suggestion = suggestion
    @comment = comment
    @url  = get_host + "suggestions/#{@suggestion.id}"
    mail(to: email, subject: 'Suggestion Box - New Comment')
  end
  
  def info_for_supporters(comment)
    @suggestion = comment.suggestion
    @comment = comment
    @url  = get_host + "suggestions/#{@suggestion.id}"
    mail(to: @comment.email, subject: 'Suggestion Box - Thanks for your support')
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
