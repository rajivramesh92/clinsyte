describe DiseaseSerializer do

  context 'when an object is displayed using Disease Serializer' do
    let!(:disease) { FactoryGirl.create(:disease) }

    before do
      @symptom1 = disease.symptoms.create(:name => 'sympton1')
      @symptom2 = disease.symptoms.create(:name => 'sympton2')
      @medication1 = disease.medications.create(:name => 'medication1', :description => 'description1')
    end

    it "should render the object with the attributes defined in the disease controller" do
      expect(DiseaseSerializer.new(disease).as_json).to include({
        :name => disease.condition.name,
        :diagnosis_date => disease.diagnosis_date.to_time.strftime("%s%3N"),
        :symptoms => [
          {
            :id => @symptom1.id,
            :name => @symptom1.name
          },
          {
            :id => @symptom2.id,
            :name => @symptom2.name
          }
        ],
        :medications => [
          {
            :id => @medication1.id,
            :name => @medication1.name,
            :description => @medication1.description
          }
        ]
      })
    end
  end

  context 'when the object is displayed using Disease Serializer with some invalid parameters' do
    let!(:disease) { FactoryGirl.create(:disease) }

    before do
      @symptom1 = disease.symptoms.create(:name => 'sympton1')
      @symptom2 = disease.symptoms.create(:name => 'sympton2')
      @medication1 = disease.medications.create(:name => 'medication1', :description => nil)
    end

    it "should not raise error while displaying the data" do
      expect(DiseaseSerializer.new(disease).as_json).to include({
        :name => disease.condition.name,
        :diagnosis_date => disease.diagnosis_date.to_time.strftime("%s%3N"),
        :symptoms => [
          {
            :id => @symptom1.id,
            :name => @symptom1.name
          },
          {
            :id => @symptom2.id,
            :name => @symptom2.name
          }
        ],
        :medications => [
          {
            :id => @medication1.id,
            :name => @medication1.name,
            :description => nil
          }
        ]
      })
    end
  end

end