class TherapyDetailsSerializer < BaseSerializer

  attributes :strain,
    :tag_with_compounds,
    :untagged_compounds

  private

  def strain
    StrainSerializer.new(object).as_json
  end

  def tag_with_compounds
    associated_tags.map do |tag|
      compound_groups = get_compound_groups(tag)
        {
          :tag => TagSerializer.new(tag).as_json,
          :compounds => compound_groups
        }
    end
  end

  def get_compound_groups(tag)
    tag.compound_strain_connections.map do |compound_strain_connection|
      compound = compound_strain_connection.compound_strain.compound
      get_compound_details(compound) if associated_compounds.include?(compound)
    end
    .compact.uniq
  end

  def get_compound_details(compound)
    strain_connection = compound.compound_strains.find_by(:strain => object)
    {
      :id => compound.id,
      :name => compound.name,
      :details => {
        :high => strain_connection.high.to_f,
        :average => strain_connection.average.to_f,
        :low => strain_connection.low.to_f
      }
    }
  end

  def associated_tags
    object.compound_strains.map { |compound_strain| compound_strain.tags }.flatten.uniq
  end

  def associated_compounds
    object.compounds
  end

  def untagged_compounds
    get_untagged_compound_ids.map do |compound_strain_id|
      compound_strain_object = CompoundStrain.find(compound_strain_id)
      {
        :id => compound_strain_object.compound.id,
        :name => compound_strain_object.compound.name,
        :details => {
          :high => compound_strain_object.high.to_f,
          :average => compound_strain_object.average.to_f,
          :low => compound_strain_object.low.to_f
        }
      }
    end
  end

  def get_untagged_compound_ids
    compound_strain_connection_ids = object.compound_strains.map &:id
    tagged_compound_strain_ids = CompoundStrainTagConnection.where(:compound_strain_id => compound_strain_connection_ids).map(&:compound_strain_id).uniq
    untagged_compound_connection_ids = compound_strain_connection_ids - tagged_compound_strain_ids
  end

end