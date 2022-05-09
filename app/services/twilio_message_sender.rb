class TwilioMessageSender

  TWILLIO_CLIENT = Twilio::REST::Client.new

  def self.send_verification_code(to, verification_code)
    TWILLIO_CLIENT.messages.create({
      :from => ENV['TWILLIO_PHONE_NUMBER'],
      :to => to,
      :body => "Your Clinsyte mobile verification code is #{verification_code}."
    })
  end

  def self.send_reminder(to, strain)
    TWILLIO_CLIENT.messages.create({
      :from => ENV['TWILLIO_PHONE_NUMBER'],
      :to => to,
      :body => "It's time to take the medicine - '#{strain}'"
    })
  end

  def self.send_survey_notification(to)
    TWILLIO_CLIENT.messages.create({
      :from => ENV['TWILLIO_PHONE_NUMBER'],
      :to => to,
      :body => "You have received a new survey. Please go to www.Clinsyte.com immediately and complete your survey to track your progress."
    })
  end

end
