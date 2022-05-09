# Worker to send SMS which carries verification code

class VerificationCodeSender
  include Sidekiq::Worker

  # Sidekiq config for this worker
  sidekiq_options :retry => 1, :queue => :sms, :backtrace => true

  def perform(options)
    options = options.symbolize_keys
    TwilioMessageSender.send_verification_code(options[:to], options[:verification_code])
  end

end