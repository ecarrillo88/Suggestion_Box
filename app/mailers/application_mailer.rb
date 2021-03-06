class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@suggestion-box.com'
  layout 'mailer'

  def get_host
    if Rails.env == "production"
      return "https://tfg-suggestion-box.herokuapp.com/#{locale}/"
    else
      return "http://localhost:3000/#{locale}/"
    end
  end
end
