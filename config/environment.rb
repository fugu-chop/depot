# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

Rails.application.configure do
  # Don't send emails in any environment
  # Append to ActionMailer::Base.deliveries only
  config.action_mailer.delivery_method = :test
  # Needs a host for email testing purposes
  config.action_mailer.default_url_options = { :host => "localhost:3000" }
end