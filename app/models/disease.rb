require 'audit'

class Disease < ActiveRecord::Base

  # Associations
  has_many :symptom_connections, {
    :class_name => 'DiseaseSymptomConnection',
    :dependent => :destroy
  }
  has_many :medication_connections, {
    :class_name => 'DiseaseMedicationConnection',
    :dependent => :destroy
  }
  has_many :symptoms, :through => :symptom_connections
  has_many :medications, :through => :medication_connections
  belongs_to :condition
  belongs_to :patient, :class_name => 'User'

  # Validations
  validates_presence_of :condition
  validates_presence_of :patient
  validates_presence_of :diagnosis_date

  # Delegations
  delegate :name, :to => :condition

  # Nested attributes
  accepts_nested_attributes_for :symptoms, :medications, {
    :allow_destroy => true
  }

  # For tracking version of the record
  audited :only => [ :condition_id, :diagnosis_date ], :associated_with => :patient

  def name=(value)
    return unless value.present?
    self.condition = Condition.find_or_initialize_by(:name => value)
  end

  def get_activity_value_for(activity)
    if activity.update?
      return activity.audited_changes unless activity.audited_changes.include?('condition_id')
      conditions = Condition.where(:id => activity.audited_changes.delete('condition_id'))
      activity.audited_changes['condition'] = conditions.map(&:name)
      activity.audited_changes
    else
      name
    end
  end

  private

  def autosave_associated_records_for_medications
    autosave_associated_records({
      :association => medications,
      :class => Medication,
      :connector => medication_connections,
      :get_params => proc { | r | { :name => r.name, :description => r.description } }
    })
  end

  def autosave_associated_records_for_symptoms
    autosave_associated_records({
      :association => symptoms,
      :class => Symptom,
      :connector => symptom_connections,
      :get_params => proc { | r | { :name => r.name } }
    })
  end

  def autosave_associated_records(options)
    options[:association].each do | record |
      record_name = options[:class].to_s.downcase
      if record._destroy
        options[:connector].send("find_by_#{record_name}_id", record.id).try(:destroy)
      else
        connection = options[:connector].find_or_initialize_by("#{record_name}_id" => record.id)
        record = options[:class].find_or_create_by(options[:get_params].call(record))
        connection.update(record_name => record)
      end
    end
  end
end
