# Service to filter patients based on different conditions for sending the Surveys

class SurveyFilter

  # patients => Array of patient_ids belonging to physician's careteam
  # filters => Array of objects having keys in [ conditions, therapies ]
  def initialize(patients, filters)
    @patients = patients
    @filters = filters || []
  end

  def filter
    return @patients if @filters.blank?

    @patients.select do |patient_id|
      set_patient(patient_id)

      results = []
      results << (patient_conditions & @filters[:conditions]).present? if @filters[:conditions].present?
      results << (patient_therapies & @filters[:therapies]).present? if @filters[:therapies].present?

      ( results.all? { |result| result==true } )
    end
  end

  def patient_conditions
    @patient.conditions.map(&:id)
  end

  def patient_therapies
    @patient.strains.map(&:id)
  end

  def set_patient(id)
    @patient = User.find(id) rescue nil
    raise "Needs to be a patient" unless @patient.try("patient?")
  end

end