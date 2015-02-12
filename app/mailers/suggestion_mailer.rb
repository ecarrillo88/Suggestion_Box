class SuggestionMailer < ApplicationMailer
  default from: 'no-reply@suggestion-box.com'
 
  def suggestion_validation_email(suggestion)
    @suggestion = suggestion
    @url  = "http://localhost:3000/suggestions/validation/#{@suggestion.token_validation}"
    mail(to: @suggestion.email, subject: 'Suggestion Box - Suggestion validation')
  end
end
