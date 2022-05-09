describe CareteamSerializer do

  context 'when an object is displayed using Careteam Serializer' do
    let(:patient) { FactoryGirl.create(:user) }

    before do
      @careteam = FactoryGirl.create(:careteam, :patient => patient)
    end

    it 'should display the object with the attributes defined in the CareteamSerializer' do
      expect(CareteamSerializer.new(@careteam).as_json).to include(
        {
          :id => @careteam.id,
          :patient => {
            :id => @careteam.patient.id,
            :name => @careteam.patient.user_name,
            :gender => @careteam.patient.gender,
            :role => @careteam.patient.role.name,
            :location => @careteam.patient.location.capitalize,
            :admin => @careteam.patient.admin?,
            :study_admin => @careteam.patient.study_admin?
          }
        }
      )
    end
  end

end