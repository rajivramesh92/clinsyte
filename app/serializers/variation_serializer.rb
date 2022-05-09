class VariationSerializer < BaseSerializer

  attributes :id,
    :name,
    :chromosome,
    :position,
    :genotype,
    :maf,
    :phenotypes


  def phenotypes
    serialize_collection(object.phenotypes, PhenotypeSerializer)
  end

end