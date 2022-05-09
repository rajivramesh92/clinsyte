class TreatmentDatum < ActiveRecord::Base

  # Assosiations
  belongs_to :treatment_plan_therapy

  # Validation
  validates_presence_of :treatment_plan_therapy

  # Delegate
  delegate :patient, :to => :treatment_plan_therapy

  # Scopes
  scope :today, -> ( patient_utc_time ) { where("date(created_at) = ?", patient_utc_time) }

  def overdosage?
    return false if prescribed_dosage_count.nil?
    intake_count > prescribed_dosage_count.to_i
  end

  def remindable?
    return true if prescribed_dosage_count.nil?
    !( intake_count >= prescribed_dosage_count.to_i )
  end

  def prescribed_dosage_count
    treatment_plan_therapy.get_maximum_dosage_count
  end

  def increment_intake_count
    update({
      :intake_count => ( intake_count + 1 ),
      :last_intake  => DateTime.now
    })
  end

end
