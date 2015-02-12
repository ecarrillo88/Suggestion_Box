class SuggestionMailer < ApplicationMailer
  default from: 'no-reply@suggestion-box.com'
 
  def suggestion_validation_email(suggestion)
    @suggestion = suggestion
    if Rails.env == "production"
      host = "https://tfg-suggestion-box.herokuapp.com/"
    else
      host  = "http://localhost:3000/"
    end
    @url  = host + "suggestions/validation/#{@suggestion.token_validation}"
    mail(to: @suggestion.email, subject: 'Suggestion Box - Suggestion validation')
  end
end
