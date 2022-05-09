class Request < ActiveRecord::Base

  belongs_to :sender, :class_name => "User"
  belongs_to :recipient, :class_name => "User"

  enum :status => [
    :pending,
    :accepted,
    :declined,
    :cancelled
  ]

  # Validations
  validates :sender, :presence => true
  validates :recipient, :presence => true

  # Callbacks
  after_create :create_notification
  after_save :add_to_careteam

  alias_method :accept!, :accepted!
  alias_method :decline!, :declined!
  alias_method :cancel!, :cancelled!

  def add_to_careteam
    if status_was.eql?("pending") && !status.eql?("pending")
      physician, patient = sender.physician? ? [ sender, recipient ] : [ recipient, sender ]
      patient.careteam.add_member(physician) if status.eql?("accepted")

      initiate_notification unless cancelled?
    end
  end

  def initiate_notification
    category = sender.physician? ? "careteam_join_request_#{status}" : "careteam_request_#{status}"
    create_notification(category.to_sym)
  end

  def self.make_between(sender, recipient)
    request = Request.where({
      :sender => sender,
      :recipient => recipient
    }).last rescue nil

    if request.present? && request.pending?
      'Already invited to the careteam'
    else
      Request.create(:sender => sender, :recipient => recipient)
    end
  end

  def delete_notification
    Notification.where({
      :sender => sender,
      :recipient => recipient,
      :category => [
        Notification.categories[:careteam_request_initiated],
        Notification.categories[:careteam_join_request_initiated]
      ]
    }).last.try(:destroy)
  end

  private

  def create_notification(category = nil)
    category ||= get_category
    Notification.create(notification_attributes_for(category))
  end

  def notification_attributes_for(category)
    source, destination = is_initiation_request(category) ? [ sender, recipient ] : [ recipient, sender ]
    {
      :sender => source,
      :recipient => destination,
      :message => I18n.t("notifications.#{category}", :count => 1, :sender => source.user_name),
      :category => category.to_s
    }
  end

  def get_category
    sender.physician? ? :careteam_join_request_initiated : :careteam_request_initiated
  end

  def is_initiation_request(category)
    category.to_s.split("_").last.eql?("initiated")
  end

end
