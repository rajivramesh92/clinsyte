describe StrainSerializer do
  
  context 'when an object is displayed using StrainSerializer' do
    let!(:strain) { FactoryGirl.create(:strain) }

    it 'should display the object with the attributes defined in Strain Serializer' do
      expect(StrainSerializer.new(strain).as_json).to eq({
        :id => strain.id,
        :name => strain.name
        })
    end
  end
  
end