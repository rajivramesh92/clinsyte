class DiseaseSerializer < BaseSerializer

  attributes :id,
    :name,
    :diagnosis_date,
    :symptoms,
    :medications

  def symptoms
    serialize_collection(object.symptoms, SymptomSerializer)
  end

  def medications
    serialize_collection(object.medications, MedicationSerializer)
  end

  def diagnosis_date
    object.diagnosis_date.to_time.strftime("%s%3N")
  end

end
