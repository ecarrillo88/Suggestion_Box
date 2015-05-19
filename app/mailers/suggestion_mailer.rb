class SuggestionMailer < ApplicationMailer

  def suggestion_validation_email(suggestion)
    @suggestion = suggestion
    @url  = get_host + "suggestion_validation/#{@suggestion.token_validation}"
    mail(to: @suggestion.email, subject: 'Suggestion Box - New suggestion validation')
  end

  def edit_suggestion_email_validation(suggestion)
    @suggestion = suggestion
    @url  = get_host + "suggestions/#{@suggestion.slug}/edit/#{@suggestion.token_validation}"
    mail(to: @suggestion.email, subject: 'Suggestion Box - Edit suggestion validation')
  end

  def delete_suggestion_email_validation(suggestion)
    @suggestion = suggestion
    @url  = get_host + "suggestions/#{@suggestion.slug}/delete/#{@suggestion.token_validation}/"
    mail(to: @suggestion.email, subject: 'Suggestion Box - Delete suggestion confirmation')
  end

  def info_suggestion_has_been_deleted(suggestion, email)
    @suggestion = suggestion
    @url  = get_host
    mail(to: email, subject: "Suggestion Box - Suggestion '#{@suggestion.title}' has been deleted")
  end
end
