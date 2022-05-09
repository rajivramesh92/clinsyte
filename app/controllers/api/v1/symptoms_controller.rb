class Api::V1::SymptomsController < Api::V1::BaseController
  include Concerns::Searchable

  @@klass = Symptom
  @@serializer = SymptomSerializer

end
