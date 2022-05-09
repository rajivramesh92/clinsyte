class CareteamSummarySerializer < BaseSerializer

  attributes :summary

  private

  def summary
    if object.physician?
      careteam_patient_list = object.careteams.map{ |careteam| careteam.patient }
      careteam_patient_list.map do | patient |
      last_appointment_date = User.recent_appointment_between(object, patient).date rescue nil
        {
          :patient => UserMinimalSerializer.new(patient),
          :last_appointment => last_appointment_date,
          :therapy_count => patient.medications.count
        }
      end
    end
  end

end