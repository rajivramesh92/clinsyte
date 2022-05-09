class Notification < ActiveRecord::Base

	belongs_to :sender, :polymorphic => true
	belongs_to :recipient, :polymorphic => true

	enum :status => [
    :unseen,
    :seen,
    :deleted
  ]

  enum :category => [
    :careteam_request_initiated,
    :careteam_request_accepted,
    :careteam_request_declined,
    :careteam_join_request_initiated,
    :careteam_join_request_accepted,
    :careteam_join_request_declined,
    :appointment_request_initiated,
    :appointment_request_accepted,
    :appointment_request_declined,
    :survey_request_initiated
  ]

  default_scope do
    where('status <> ?', Notification.statuses[:deleted]).
    order(:created_at => :desc)
  end

  alias_method :delete!, :deleted!

  validates :sender, :presence => true
  validates :recipient, :presence => true
  validates :category, :presence => true
end