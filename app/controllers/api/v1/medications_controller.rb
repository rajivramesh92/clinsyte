class Api::V1::MedicationsController < Api::V1::BaseController
  include Concerns::Searchable

  @@klass = Medication
  @@serializer = MedicationSerializer

end
