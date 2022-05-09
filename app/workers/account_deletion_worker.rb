# Worker to delete the Account if not confirmed for configured time

class AccountDeletionWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform
    User.unconfirmed.
      where('created_at <= ?', ENV['UNCONFIRMED_ACCOUNT_DELETION_PERIOD'].to_i.weeks.ago).
      destroy_all
  end

end

