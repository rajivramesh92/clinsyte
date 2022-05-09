describe VariationSerializer do
  
  context 'when an object is displayed using the VariationSerializer' do
    let!(:genetic) { FactoryGirl.create(:genetic) }
    let!(:variation) { FactoryGirl.create(:variation, :genetic => genetic) }
    let!(:phenotype) { FactoryGirl.create(:phenotype, :variation => variation) }

    it 'should render the object with the attributes defined in the VariationSerializer' do
      expect(VariationSerializer.new(variation).as_json).to eq({
        :id => variation.id,
        :name => variation.name,
        :chromosome => variation.chromosome,
        :position => variation.position,
        :genotype => variation.genotype,
        :maf => variation.maf,
        :phenotypes => [
          {
            :id => phenotype.id,
            :name => phenotype.name
            }]
        })
    end
  end
end