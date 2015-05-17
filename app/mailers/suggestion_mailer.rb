class SuggestionMailer < ApplicationMailer

  def suggestion_validation_email(suggestion)
    @suggestion = suggestion
    @url  = get_host + "suggestion_validation/#{@suggestion.token_validation}"
    mail(to: @suggestion.email, subject: 'Suggestion Box - New suggestion validation')
  end

  def edit_suggestion_email_validation(suggestion)
    @suggestion = suggestion
    @url  = get_host + "edit_suggestion_validation/#{@suggestion.token_validation}"
    mail(to: @suggestion.email, subject: 'Suggestion Box - Edit suggestion validation')
  end

  def delete_suggestion_email_validation(suggestion)
    @suggestion = suggestion
    @url  = get_host + "/suggestions/#{@suggestion.slug}/#{@suggestion.token_validation}/"
    mail(to: @suggestion.email, subject: 'Suggestion Box - Delete suggestion confirmation')
  end
end
