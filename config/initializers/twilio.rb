# Twilio Configuration

Twilio.configure do |config|
  config.account_sid = ENV['TWILLIO_ACCOUNT_SID']
  config.auth_token = ENV['TWILLIO_AUTH_TOKEN']
end