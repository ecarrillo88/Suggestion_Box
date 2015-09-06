class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@suggestion-box.com'
  layout 'mailer'

  def get_host
    host = ENV['APP_HOST'] || "http://localhost:3000"
    "#{host}/#{locale}/"
  end
end
