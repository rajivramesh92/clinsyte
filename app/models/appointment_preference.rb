class AppointmentPreference < ActiveRecord::Base

  belongs_to :physician, :class_name => 'User'

  # Validations
  validates :physician, :presence => true

end
