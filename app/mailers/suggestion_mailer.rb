class SuggestionMailer < ApplicationMailer

  def suggestion_validation_email(suggestion)
    @suggestion = suggestion
    @url  = get_host + "suggestion_validation/#{@suggestion.token_validation}"
    mail(to: @suggestion.email, subject: 'Suggestion Box - New suggestion validation')
  end

  def info_neighbors_suggestion_inactive(suggestion, email_neighbor)
    @suggestion = suggestion
    @url  = get_host + "suggestions/#{@suggestion.slug}/"
    mail(to: email_neighbor, subject: "Suggestion Box - Suggestion '#{@suggestion.title}' inactive")
  end

  def info_neighbors_suggestion_closed(suggestion, email_neighbor)
    @suggestion = suggestion
    @url  = get_host  + "suggestions/#{@suggestion.slug}/"
    mail(to: email_neighbor, subject: "Suggestion Box - Suggestion '#{@suggestion.title}' closed")
  end

  def info_responsible_person_suggestion_closed(suggestion, responsible_person)
    @suggestion = suggestion
    @responsible_person = responsible_person
    @url  = get_host + "suggestions/#{@suggestion.slug}/"
    mail(to: @responsible_person.email, subject: "Suggestion Box - Suggestion '#{@suggestion.title}' closed")
  end

  def report_suggestion(suggestion, responsible_person)
    @suggestion = suggestion
    @responsible_person = responsible_person
    @url  = get_host + "suggestions/#{@suggestion.slug}/"
    mail(to: @responsible_person.email, subject: 'Suggestion Box - Suggestion reported')
  end
end
