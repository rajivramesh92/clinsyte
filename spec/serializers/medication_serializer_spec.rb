describe MedicationSerializer do
  
  context 'when an object is displayed using Medication Serializer' do
    let!(:medication) { FactoryGirl.create(:medication) }

    it 'should display the object with the attributes defined in Medication Serializer' do
      expect(MedicationSerializer.new(medication).as_json).to eq({
        :id => medication.id,
        :name => medication.name,
        :description => medication.description
        })
    end
  end

  context 'when an object is displayed using MedicationSerializer with some invalid field' do
    let!(:medication) { FactoryGirl.create(:medication, :description => nil) }
    
    it 'should display object as it is without raising error' do
      expect(MedicationSerializer.new(medication).as_json).to eq({
        :id => medication.id,
        :name => medication.name,
        :description => medication.description
        })
    end
  end
end