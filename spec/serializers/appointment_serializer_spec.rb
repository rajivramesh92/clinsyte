  describe AppointmentSerializer do

  context 'when an object is displayed using Appointment Serializer' do
    let(:appointment) { FactoryGirl.create(:appointment) }

    it 'should display the object with the attributes defined in the AppointmentSerializer' do
      expect(AppointmentSerializer.new(appointment).as_json).to include({
        :id => appointment.id,
        :date => appointment.date,
        :from_time => appointment.from_time,
        :to_time => appointment.to_time,
        :patient => UserMinimalSerializer.new(appointment.patient).as_json,
        :physician => UserMinimalSerializer.new(appointment.physician).as_json
      })
    end
  end

end