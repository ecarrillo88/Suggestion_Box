class SuggestionMailer < ApplicationMailer
  default from: 'no-reply@suggestion-box.com'

  def suggestion_validation_email(suggestion)
    @suggestion = suggestion
    if Rails.env == "production"
      host = "https://tfg-suggestion-box.herokuapp.com/"
    else
      host  = "http://localhost:3000/"
    end
    @url  = host + "suggestion_validation/#{@suggestion.token_validation}"
    mail(to: @suggestion.email, subject: 'Suggestion Box - Suggestion validation')
  end

  def edit_suggestion_email_validation(suggestion)
    @suggestion = suggestion
    if Rails.env == "production"
      host = "https://tfg-suggestion-box.herokuapp.com/"
    else
      host  = "http://localhost:3000/"
    end
    @url  = host + "edit_suggestion_validation/#{@suggestion.token_validation}"
    mail(to: @suggestion.email, subject: 'Suggestion Box - Edit suggestion validation')
  end
end
