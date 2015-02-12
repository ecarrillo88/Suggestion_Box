class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@suggestion-box.com'
  layout 'mailer'
end
