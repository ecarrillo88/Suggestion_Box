namespace :scheduler do
  desc "Send an email if the suggestion has more than 30 days without new comments"
  task :send_email_if_suggestion_is_inactive => :environment do
    Suggestion.all.each do |suggestion|
      if !suggestion.notice_of_inactivity? && suggestion.has_comments?
        diff = (Time.now - suggestion.last_comment.created_at) / 86400
        if diff >= 30 # days
          suggestion.comments_email_list.each do |email|
            SuggestionMailer.info_neighbors_suggestion_inactive(suggestion, email).deliver_later
          end
          suggestion.update(notice_of_inactivity: true)
        end
      end
    end
  end

  desc "Close the suggestion after the first announcement of inactivity if there has been no new comments"
  task :close_suggestion => :environment do
    Suggestion.find_inactive_suggestions.each do |suggestion|
      if suggestion.open? && suggestion.has_comments?
        diff = (Time.now - suggestion.last_comment.created_at) / 86400
        if diff >= 37 # days
          suggestion.update(closed: true)
          suggestion.comments_email_list.each do |email|
            SuggestionMailer.info_neighbors_suggestion_closed(suggestion, email).deliver_later
          end
          CityCouncilResponsiblePerson.all.each do |responsible_person|
            SuggestionMailer.info_responsible_person_suggestion_closed(suggestion, responsible_person).deliver_later
          end
        else
          suggestion.update(notice_of_inactivity: false)
        end
      end
    end
  end
end
