class TreatmentPlanTherapy < ActiveRecord::Base

  # Associations
  belongs_to :treatment_plan, :inverse_of => :therapies
  belongs_to :strain
  has_many :dosage_frequencies, {
    :as => :entity,
    :class_name => 'FieldValue',
    :dependent => :destroy
  }
  has_many :entity_connections, {
    :class_name => 'TherapyEntityConnection',
    :inverse_of => :treatment_plan_therapy,
    :dependent => :destroy
  }
  has_many :treatment_data, :dependent => :destroy

  # Validations
  validates_presence_of :treatment_plan
  validates_presence_of :strain
  validates_presence_of :dosage_quantity
  validates_presence_of :dosage_unit
  validates_presence_of :intake_timing

  # For tracking changes to the record
  audited :only => [ :treatment_plan_id, :strain_id, :dosage_quantity,
   :dosage_unit, :intake_timing ], :associated_with => :patient

  # Enum
  enum :intake_timing => [
    :am,
    :pm,
    :as_required
  ]

  # Nested attribute
  accepts_nested_attributes_for :entity_connections, :allow_destroy => true
  accepts_nested_attributes_for :dosage_frequencies, :allow_destroy => true

  # Delegate
  delegate :patient, :to => :treatment_plan

  # Callbacks
  after_validation :validate_dosage_combinations

  # Class Methods
  def self.dosage_fields
    ['n times a day', 'no more than n times a day', 'as needed', 'every n hours']
  end

  def self.dosage_combinations
    ["1,3", "1,4", "2,3", "2,3,4", "2,4", "3,4"]
  end

  # Method to
  #   Record Intake count and Last Intake Time,
  #   Notify Overdosage for a treatment plan,
  #   Schedule reminders for next dosage
  #   Schedule Event dependent surveys if present
  def take_therapy
    todays_data = get_todays_treatment_data
    todays_data.increment_intake_count
    schedule_survey
    set_reminder(todays_data) if todays_data.remindable?
    todays_data.overdosage? ? false : true
  end

  # Sets the reminder for the next Therapy Dosage
  def set_reminder(treatment_data)
    time_gap = self.dosage_frequencies.find_by_name('every n hours')['value'].to_i rescue nil
    if time_gap.present? and treatment_data.remindable?
      schedule_time =  time_gap.hours - ENV['REMINDER_TIME_GAP'].to_i * 60  # change 905 to time_gap.hours in production
      schedule_reminder(schedule_time, 'normal_reminder')
    end
  end

  # Method to snooze the reminder as per the configured time
  def snooze_reminder
    if snoozable?
      schedule_time = ENV['SNOOZE_TIME_GAP'].to_i * 60
      schedule_reminder(schedule_time, 'snooze_reminder')
    end
  end

  # Method to check whether the reminder can be snoozed or not
  def snoozable?
    self.treatment_data.today(patient.get_local_time_in_utc.to_date).present? ? true : false
  end

  def get_maximum_dosage_count
    dosage_frequencies.detect do | dosage_field |
      ( dosage_field.name == 'n times a day' || dosage_field.name == 'no more than n times a day' )
    end
    .try(:value)
  end

  def self.activity_name
   'Therapy'
  end

  def get_activity_value_for(activity)
    changes = activity['audited_changes']
    if activity.update?
      changes = format_intake_timing(changes) if changes['intake_timing'].present?
      changes = format_strain(changes) if changes['strain_id'].present?
      changes = format_dosage_quantity(changes) if changes['dosage_quantity'].present?
      changes = format_dosage_unit(changes) if changes['dosage_unit'].present?
    else
      Strain.find(activity['audited_changes']['strain_id']).try(:name) rescue nil
    end
  end

  # Method to format intake timing for Audits
  def format_intake_timing(audited_changes)
    intake_timing = audited_changes.delete('intake_timing')
    audited_changes['intake timing'] = [ intake_timing[0].humanize, TreatmentPlanTherapy.intake_timings.key(intake_timing[1]).humanize ]
    audited_changes
  end

  # Method to format dosage_quantity for Audits
  def format_dosage_quantity(audited_changes)
    audited_changes['dosage quantity'] = audited_changes.delete('dosage_quantity')
    audited_changes
  end

  # Method to format dosage_unit for Audits
  def format_dosage_unit(audited_changes)
    audited_changes['dosage unit'] = audited_changes.delete('dosage_unit')
    audited_changes
  end

  # Method to format strain for Audits
  def format_strain(audited_changes)
    from, to = Strain.find(audited_changes.delete('strain_id')) rescue nil
    audited_changes['therapy'] = [ from.name, to.name ] unless [from, to].any? &:nil?
    audited_changes
  end

  def get_activity_association(activity)
    if self.treatment_plan.nil?
      audit = Audit.find_by({
        :auditable_type => 'TreatmentPlan',
        :auditable_id => treatment_plan_id,
        :action => 'destroy'
      })
      self.treatment_plan = audit.try(:auditable_instance)
    end

    {
      :name => 'Treatment Plan',
      :value => self.treatment_plan.try('title')
    }
  end

  private

  def get_todays_treatment_data
    treatment_data.today(patient.get_local_time_in_utc.to_date).first_or_create
  end

  # Method to schedule the Worker to send the messages and real time changes to client
  def schedule_reminder(time_gap, type)
    ReminderSenderWorker.perform_in(time_gap.seconds, type, treatment_data.last.id,
      patient.formatted_phone_number)
  end

  # Method to shedule the survey after a patient takes the medicine
  def schedule_survey
    physician = User.find(self.treatment_plan.audits.find_by_action('create').user_id) rescue nil
    dependent_surveys = physician.event_dependent_surveys rescue []
    dependent_surveys.each do | dependent_survey |
      patients = dependent_survey.receipients.map(&:receiver_id)
      if patients.include?(self.patient.id)
        EventDependentSurveySender.perform_in(dependent_survey.time.minutes, physician.id, [self.patient.id], dependent_survey.survey_id)
      end
    end
  end

  # Method to check the valid combinations for Therapy Dosages
  def validate_dosage_combinations
    unless valid_code?(create_combination_code)
      self.errors.add(:dosage_frequency, 'combinations are Invalid')
    end
  end

  def dosage_fields_hash
    Hash[TreatmentPlanTherapy.dosage_fields.map.with_index.to_a]
  end

  def create_combination_code
    dosage_frequencies.map do |dosage|
      unless dosage.marked_for_destruction?
        ( dosage_fields_hash[dosage.name] + 1 )
      end
    end
  end

  def valid_code?(combination_code)
    TreatmentPlanTherapy.dosage_combinations.any? do | combination |
      ( combination_code.compact - combination.split(',').collect! {|n| n.to_i} ).blank?
   end
  end
end
