class Appointment < ActiveRecord::Base

  belongs_to :patient, :class_name => "User"
  belongs_to :physician, :class_name => "User"

  enum :status => [
    :pending,
    :accepted,
    :declined,
    :cancelled
  ]

  # Validations
  validates :physician, :presence => true
  validates :patient, :presence => true
  validates :date, :presence => true
  validates :from_time, :presence => true, :numericality => { :greater_than_or_equal_to => 0, :less_than => 86400 }
  validates :to_time, :presence => true, :numericality => { :greater_than_or_equal_to => 0, :less_than => 86400 }
  validate :invalid_appointment_time
  validates_with AppointmentValidator, :unless => (:persisted? && :status_changed?)

  # Callbacks
  before_create :check_auto_confirm
  after_save :create_notification

  # Scopes
  scope :valid, -> do
    where("status NOT IN (?) AND date >= ?",
      statuses.values_at('declined', 'cancelled'),
      Time.now.utc.to_date)
  end

  alias_method :accept!, :accepted!
  alias_method :decline!, :declined!

  private

  # checks if from time is greater than to time
  def invalid_appointment_time
    self.errors.add(:Appointment_timings, "are Invalid") if self.from_time.to_i >= self.to_time.to_i
  end

  def create_notification(category = :appointment_request_initiated)
    return if status.eql?('cancelled')
    send_notification(category) if id_changed? && status.eql?('accepted')
    if status_was.eql?("pending") && status_changed?
      category = "appointment_request_#{status}".to_sym
    end
    send_notification(category)
  end

  def send_notification(category)
    Notification.create(notification_attributes_for(category))
  end

  def notification_attributes_for(category)
    sender, recipient = category.eql?(:appointment_request_initiated) ? [ patient, physician ] : [ physician, patient ]
    {
      :sender => sender,
      :recipient => recipient,
      :message => I18n.t("notifications.#{category}", :count => 1, :sender => sender.user_name),
      :category => category.to_s
    }
  end

  def check_auto_confirm
    self.status = 'accepted' if physician.auto_confirm
  end

end
