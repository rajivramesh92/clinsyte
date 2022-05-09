class AppointmentValidator < ActiveModel::Validator

  def validate(record)
    record.errors.add(:appointment, 'already exists') if appointment_exists?(record)
  end

  private

  def appointment_exists?(record)
    physician = record.physician
    appointment = physician.received_appointments.where("date = ? and from_time = ? and to_time = ? and status IN (0,1)", record.date, record.from_time, record.to_time ) rescue []
    appointment.present? ? true : false
  end

end