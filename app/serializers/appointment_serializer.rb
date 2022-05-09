class AppointmentSerializer < BaseSerializer

  attributes :id,
    :date,
    :from_time,
    :to_time,
    :patient,
    :physician

  private

  def patient
    UserMinimalSerializer.new(object.patient).as_json
  end

  def physician
    UserMinimalSerializer.new(object.physician).as_json
  end

end