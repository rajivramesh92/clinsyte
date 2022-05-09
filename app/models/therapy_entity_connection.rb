class TherapyEntityConnection < ActiveRecord::Base

  # Assosiations
  belongs_to :treatment_plan_therapy, :inverse_of => :entity_connections
  belongs_to :associated_entity, :polymorphic => true

  # Validations
  validates_presence_of :treatment_plan_therapy
  validates_presence_of :associated_entity

  validates_uniqueness_of :associated_entity_id,
   :scope => [ :treatment_plan_therapy_id, :associated_entity_type ]

  # Delegate
  delegate :patient, :to => :treatment_plan_therapy

  # For tracking changes to the record
  audited :associated_with => :patient

  def self.activity_name
   'Therapy association'
  end

  def get_activity_value_for(activity)
    Object.const_get(activity['audited_changes']['associated_entity_type']).find(activity['audited_changes']['associated_entity_id']).name
  end

  def get_activity_association(activity)
    if self.treatment_plan_therapy.nil?
      audit = Audit.find_by({
        :auditable_type => 'TreatmentPlanTherapy',
        :auditable_id => treatment_plan_therapy_id,
        :action => 'destroy'
      })
      self.treatment_plan_therapy = audit.try(:auditable_instance)
    end

    {
      :name => 'Treatment Plan Therapy',
      :value => self.treatment_plan_therapy.try('strain').try('name')
    }
  end

end
