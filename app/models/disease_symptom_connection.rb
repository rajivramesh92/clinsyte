class DiseaseSymptomConnection < ActiveRecord::Base

  # Associations
  belongs_to :disease
  belongs_to :symptom
  has_one :patient, :through => :disease

  # Validations
  validates_presence_of :disease, :symptom
  validates_uniqueness_of :disease_id, :scope => :symptom_id

  # Delegations
  delegate :name, :to => :symptom

  # For tracking version of the record
  audited :only => [ :disease_id, :symptom_id ], :associated_with => :patient

  # Class Methods
  def self.activity_name
    'Symptom'
  end

  # Instance Methods
  def get_activity_value_for(activity)
    if activity.update?
      from, to = Symptom.where(:id => activity.audited_changes['symptom_id'])
      { :name => [ from.name, to.name ] }
    else
      Symptom.find(activity.audited_changes['symptom_id']).try(:name)
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
