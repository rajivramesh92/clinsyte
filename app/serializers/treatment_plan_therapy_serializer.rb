class TreatmentPlanTherapySerializer < BaseSerializer

  attributes :id,
    :strain,
    :dosage_quantity,
    :dosage_unit,
    :message,
    :intake_timing,
    :dosage_frequency,
    :association_entities

  private

  def strain
    StrainSerializer.new(object.strain).as_json
  end

  def dosage_frequency
    object.dosage_frequencies.map do | field |
      {
        :id => field.id,
        :name => field.name,
        :value => field.value
      }
    end
  end

  def association_entities
    object.entity_connections.map do | connection |
      entity_object = Object.const_get(connection.associated_entity_type).find(connection.associated_entity_id)
      {
        :id => connection.id,
        :entity_type => connection.associated_entity_type.parameterize.downcase,
        :entity_object => {
          :id => entity_object.id,
          :name => entity_object.name
        }
      }
    end
  end

end