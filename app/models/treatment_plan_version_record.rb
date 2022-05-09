class TreatmentPlanVersionRecord < ActiveRecord::Base

  # Associations
  belongs_to :user_survey_form
  belongs_to :treatment_plan

  # Validation
  validates_presence_of :user_survey_form
  validates_presence_of :treatment_plan
  validates_presence_of :treatment_plan_version

end
