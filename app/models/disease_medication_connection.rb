class DiseaseMedicationConnection < ActiveRecord::Base

  # Associations
  belongs_to :disease
  belongs_to :medication
  has_one :patient, :through => :disease

  # Validations
  validates_presence_of :disease, :medication
  validates_uniqueness_of :disease_id, :scope => :medication_id

  # Delegations
  delegate :name, :to => :medication
  delegate :description, :to => :medication

  # For tracking version of the record
  audited :only => [ :disease_id, :medication_id ], :associated_with => :patient

  # Class Methods
  def self.activity_name
    'Medication'
  end

  # Instance Methods
  def get_activity_value_for(activity)
    if activity.update?
      from, to = Medication.where(:id => activity.audited_changes['medication_id'])

      # TODO: Return only the changed attrs.
      {
        :name => [ from.name, to.name ],
        :description => [ from.description, to.description ]
      }
    else
      Medication.find(activity.audited_changes['medication_id']).try(:name)
    end
  end

  def get_activity_association(activity)
    if self.disease.nil?
      audit = Audit.find_by({
        :auditable_type => 'Disease',
        :auditable_id => disease_id,
        :action => 'destroy'
      })
      self.disease = audit.try(:auditable_instance)
    end

    {
      :name => 'Condition',
      :value => self.disease.try(:name)
    }
  end

end
