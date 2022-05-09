describe AppointmentValidator do

  context 'when the user attempts to create an appointment on an empty slot' do
    let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
    let!(:patient) { FactoryGirl.create(:user) }

    it 'should create the appointment' do
      appointment = FactoryGirl.build(:appointment, :patient => patient, :physician => patient, :date => Date.current, :from_time => rand(0...3999), :to_time => rand(4000...86400))
      AppointmentValidator.new.validate(appointment)
      expect(appointment.errors.full_messages).to be_empty
    end
  end

  context 'when the user attempts to create an appointment on a pre-occupied slot' do
    let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
    let!(:appointment) { FactoryGirl.create(:appointment, :physician => physician, :date => Date.current, :from_time => rand(0...3999), :to_time => rand(4000...86400)) }

    it 'should not create the appointment' do
      appointment1 = FactoryGirl.build(:appointment, :physician => physician, :date => Date.current, :from_time => appointment.from_time, :to_time => appointment.to_time)
      AppointmentValidator.new.validate(appointment1)
      expect(appointment1.errors.full_messages).to include('Appointment already exists')
    end
  end

  context 'when the user attempts to create an appointment with different date and same from_time and to_time' do
    let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
    let!(:appointment) { FactoryGirl.create(:appointment, :physician => physician, :date => Date.yesterday, :from_time => rand(0...3999), :to_time => rand(4000...86400)) }

    it 'should create the appointment' do
      appointment1 = FactoryGirl.build(:appointment, :physician => physician, :date => Date.current, :from_time => appointment.from_time, :to_time => appointment.to_time)
      AppointmentValidator.new.validate(appointment1)
      expect(appointment1.errors.full_messages).to be_empty
    end
  end

  context 'when the user attempts to create an appointment with some other physician on same date and slot timings' do
    let!(:physician1) { FactoryGirl.create(:user_with_physician_role) }
    let!(:physician2) { FactoryGirl.create(:user_with_physician_role) }
    let!(:appointment) { FactoryGirl.create(:appointment, :physician => physician1, :date => Date.current, :from_time => rand(0...3999), :to_time => rand(4000...86400)) }

    it 'should create the appointment' do
      appointment1 = FactoryGirl.build(:appointment, :physician => physician2, :date => Date.current, :from_time => appointment.from_time, :to_time => appointment.to_time)
      AppointmentValidator.new.validate(appointment1)
      expect(appointment1.errors.full_messages).to be_empty
    end
  end

  context 'when the user attempts to create an appointment on a slot with declined appointment status' do
    let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
    let!(:appointment) { FactoryGirl.create(:appointment, :physician => physician, :date => Date.current, :from_time => rand(0...3999), :to_time => rand(4000...86400)) }
    before do
      appointment.declined!
    end

    it 'should create the appointment' do
      appointment1 = FactoryGirl.build(:appointment, :physician => physician, :date => Date.current, :from_time => appointment.from_time, :to_time => appointment.to_time)
      AppointmentValidator.new.validate(appointment1)
      expect(appointment1.errors.full_messages).to be_empty
    end
  end

  context 'when the user attempts to create an appointment with some invalid parameters' do
    context 'when the physician passed is as nil' do
      it 'should not raise any exception' do
        appointment = FactoryGirl.build(:appointment, :physician => nil, :date => Date.current, :from_time => 2000, :to_time => 4000)
        expect do
          AppointmentValidator.new.validate(appointment)
        end
          .not_to raise_exception
        expect(appointment.errors.full_messages).to be_empty
      end
    end

    context 'when the from time passed is negative' do
      it 'should not raise any exception' do
        appointment = FactoryGirl.build(:appointment, :physician => nil, :date => Date.current, :from_time => -100, :to_time => 4000)
        expect do
          AppointmentValidator.new.validate(appointment)
        end
          .not_to raise_exception
        expect(appointment.errors.full_messages).to be_empty
      end
    end

    context 'when the date passed is nil' do
      it 'should not raise any exception' do
        appointment = FactoryGirl.build(:appointment, :physician => nil, :date => nil, :from_time => 2000, :to_time => 4000)
        expect do
          AppointmentValidator.new.validate(appointment)
        end
          .not_to raise_exception
        expect(appointment.errors.full_messages).to be_empty
      end
    end
  end
  
end