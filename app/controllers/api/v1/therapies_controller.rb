class Api::V1::TherapiesController < Api::V1::BaseController
  include Concerns::Searchable

  @@klass = Strain
  @@serializer = StrainSerializer

  before_filter :set_strain, :only => [ :show ]

  def list
    strains = Strain.all
    success_serializer_responder(strains, ConditionSerializer)
  end

  def show
    success_serializer_responder(@strain, TherapyDetailsSerializer)
  end

  private

  def set_strain
    @strain = Strain.find(params[:id]) rescue nil
    error_serializer_responder('No such Therapy exists') unless @strain
  end

end
