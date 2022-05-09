describe SymptomSerializer do

  context 'when an object is displayed using SymptomSerializer' do
    let!(:symptom) { FactoryGirl.create(:symptom) }

    it 'should display the object with the attributes defined in the SymptomSerilaizer' do
      expect(SymptomSerializer.new(symptom).as_json).to eq({
        :id => symptom.id,
        :name => symptom.name
        })
    end
  end
  
end