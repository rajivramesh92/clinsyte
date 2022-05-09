class TreatmentPlan < ActiveRecord::Base

  # Assosiations
  belongs_to :patient, :class_name => 'User'
  has_many :therapies, :class_name => 'TreatmentPlanTherapy', :inverse_of => :treatment_plan
  belongs_to :creator, :class_name => 'User'

  # Validations
  validates_presence_of :patient
  validates_presence_of :title
  validates_presence_of :creator

  # Nested Attributes
  accepts_nested_attributes_for :therapies, :allow_destroy => true

  # For tracking changes to the record
  audited :except => [ :current_version, :patient_id ], :associated_with => :patient

  # Validations
  before_validation :check_for_pending_tpd_surveys
  before_save :upgrade_version

  def self.activity_name
   'Treatment Plan'
  end

  def get_activity_value_for(activity)
    if activity.update?
      from, to = User.where(:id => activity.audited_changes.delete('creator_id')) rescue nil
      activity['audited_changes']['creator'] = { :name => [from.user_name, to.user_name] } unless [from, to].any? &:nil?
    else
      title
    end
  end

  # Method to notify if creator of treatment plan is in Patient's careteam or not
  def orphaned?
    begin
      creator.physician? ? !creator.associated_patients.include?(patient.id) : false
    rescue Exception => e
      false
    end
  end

  # Method to check if the patient of the treatment plan has some pending treatment plans
  def check_for_pending_tpd_surveys
    if patient.has_pending_tpd_surveys?
      self.errors.add("can not be updated".to_sym, 'as the Patient has pending Surveys')
    end
  end

  private

  # Method to upgrade the Treatment Plan version once any change is detected to the Treatment Plan
  def upgrade_version
    self.current_version = current_version.next if treatment_plan_is_changed?
  end

  # Method to check if Treatment Plan has been changed
  # Change in Treatment Plan refers to changes in any of the therapies, associated_entities or dosage_frequencies related to Treatment Plan
  def treatment_plan_is_changed?
    results = []
    results << changed?
    therapies.each do | therapy |
      results << ( therapy.changed? or therapy.marked_for_destruction? )
      therapy.dosage_frequencies.each do |dosage|
        results << ( dosage.changed? or dosage.marked_for_destruction? )
      end
      therapy.entity_connections.each do |connection|
        results << ( connection.changed? or connection.marked_for_destruction? )
      end
    end
    results.all? { |result| result.eql?(false) } ? false : true
  end

end
