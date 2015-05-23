namespace :scheduler do
  desc "This task is called every day by the Heroku scheduler add-on"
  task :send_email_if_suggestion_is_inactive => :environment do
    Suggestion.all.each do |suggestion|
      if !suggestion.notice_of_inactivity? && suggestion.has_comments?
        diff = (Time.now - suggestion.last_comment.created_at) / 86400
        if diff >= 30
          suggestion.comments_email_list.each do |email|
            SuggestionMailer.info_suggestion_inactive(suggestion, email).deliver_later
          end
          suggestion.update(notice_of_inactivity: true)
        end
      end
    end
  end
end
