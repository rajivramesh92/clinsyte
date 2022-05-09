class Slot < ActiveRecord::Base

  belongs_to :physician, :class_name => "User"

  enum :day => [
    :sunday,
    :monday,
    :tuesday,
    :wednesday,
    :thursday,
    :friday,
    :saturday
  ]

  # Default scope
  default_scope { order(:day) }

  # Validations
  validates :physician, :presence => true
  validates :from_time, :presence => true, :numericality => { :greater_than_or_equal_to => 0, :less_than => 86400 }
  validates :to_time, :presence => true, :numericality => { :greater_than_or_equal_to => 0, :less_than => 86400 }
  validate :slot_validity
  validate :physician_validity
  validates_with TimeOverlapValidator

  # Scopes
  scope :available, -> { where(:type => 'AvailableSlot') }
  scope :unavailable, -> { where(:type => 'UnavailableSlot') }

  private

  # Checks if from_time is less than to_time
  def slot_validity
    self.errors.add(:slot_timings, "are Invalid") if self.from_time.to_i >= self.to_time.to_i
  end

  # Checks if the user is a physician to save a record
  def physician_validity
    errors.add(:physician, 'is Invalid') unless physician.present? && physician.physician?
  end

end
