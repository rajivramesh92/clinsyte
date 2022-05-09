module Concerns
  module Mapper
    extend ActiveSupport::Concern

    @@mapper = {
      'Condition'  => 'Disease',
      'Symptom'    => 'DiseaseSymptomConnection',
      'Medication' => 'DiseaseMedicationConnection',
      'Therapy'    => 'DiseaseTherapyConnection',
      'Basic info' => 'User',
    }

    # Readers
    cattr_reader :mapper

    class_methods do
      def auditable_class_for(model)
        @@mapper[model.to_s]
      end
    end
  end
end
