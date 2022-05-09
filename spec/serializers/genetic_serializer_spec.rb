describe GeneticSerializer do
  
  context 'when an object is displayed using Genetic Serializer' do
    let!(:genetic) { FactoryGirl.create(:genetic) }
    let!(:variation1) { FactoryGirl.create(:variation, :genetic => genetic) }
    let!(:variation2) { FactoryGirl.create(:variation, :genetic => genetic) }

    it "should render the object with the attributes defined in the disease controller" do
      expect(GeneticSerializer.new(genetic).as_json).to eq({
        :id => genetic.id,
        :name => genetic.name,
        :variations => [
          {
            :id => variation1.id,
            :name => variation1.name,
            :chromosome => variation1.chromosome,
            :position => variation1.position,
            :genotype => variation1.genotype,
            :maf => variation1.maf,
            :phenotypes => []
          },
          {
            :id => variation2.id,
            :name => variation2.name,
            :chromosome => variation2.chromosome,
            :position => variation2.position,
            :genotype => variation2.genotype,
            :maf => variation2.maf,
            :phenotypes => []
          }
        ]
      })
    end
  end

  context 'when an object is displayed using Genetic Serializer and no variations exists' do
    let!(:genetic) { FactoryGirl.create(:genetic) }

    it "should render the object with no variations" do
      expect(GeneticSerializer.new(genetic).as_json).to eq({
        :id => genetic.id,
        :name => genetic.name,
        :variations => []
      })
    end
  end

end