class SupporterMailer < ApplicationMailer
  default from: 'no-reply@suggestion-box.com'
 
  def info_new_comment(suggestion, comment, email)
    @suggestion = suggestion
    @comment = comment
    if Rails.env == "production"
      host = "https://tfg-suggestion-box.herokuapp.com/"
    else
      host  = "http://localhost:3000/"
    end
    @url  = host + "suggestions/#{@suggestion.id}"
    mail(to: email, subject: 'Suggestion Box - New Comment')
  end
end
