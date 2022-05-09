class GeneticSerializer < BaseSerializer

  attributes :id,
    :name,
    :variations

  def variations
    serialize_collection(object.variations, VariationSerializer)
  end

end