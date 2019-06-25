# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :user_name => 'peggy910',
  :password => 'Sh3rlock910!',
  :address => 'smtp.sendgrid.net',
  :domain => 'yourdomain.com'
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}