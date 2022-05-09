# Worker to send emails
class EmailWorker
  include Sidekiq::Worker

  # Sidekiq config for this worker
  sidekiq_options :retry => 3, :queue => :email, :backtrace => true

  def perform(options)
    options = options.deep_symbolize_keys
    options[:emailer_class].constantize.send(options[:method], *options[:arguments]).deliver
  end

end