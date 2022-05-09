require 'rails_helper'

RSpec.describe Appointment, type: :model do

  describe '#assosiations' do
    it { is_expected.to belong_to(:physician).class_name(:User) }
    it { is_expected.to belong_to(:patient).class_name(:User) }
  end

  describe '#validations' do
    required_attributes = [
      :physician,
      :patient,
      :date,
      :from_time,
      :to_time
    ]

    required_attributes.each do | attribute |
      it { is_expected.to validate_presence_of(attribute) }
    end

    context '#AppointmentValidator' do
      let!(:appointment) { FactoryGirl.create(:appointment, :from_time => 2000, :to_time => 4000) }
      context 'when an attempt is made to create an appointment on a pre-occupied appointment slot' do
        it 'should not let the record to be saved and return with an error message' do
          appointment1 =  FactoryGirl.build(:appointment, :physician => appointment.physician, :from_time => 2000, :to_time => 4000)
          expect(appointment1).not_to be_valid
          expect(appointment1.errors.full_messages).to include('Appointment already exists')
        end
      end
      context 'when an attempt is made to create an appointment on an empty slot' do
        it 'should create the record' do
          appointment1 =  FactoryGirl.build(:appointment, :physician => appointment.physician, :from_time => 4000, :to_time => 6000)
          expect(appointment1).to be_valid
          expect(appointment1.errors.full_messages).to be_empty
        end
      end
    end
  end

  describe '#Callbacks' do
    context '#after save callback' do
      context 'when the appointment is saved successfully' do
        let(:physician) { FactoryGirl.create(:user_with_physician_role) }
        let(:patient) { FactoryGirl.create(:user) }
        it 'should generate a notification object based on the record saved' do
          expect do
            Appointment.create(:physician => physician, :patient => patient, :date => Date.current, :from_time => 2000, :to_time => 4000)
          end
          .to change(Notification, :count).by(1)

          notification = Notification.first
          expect(notification).to have_attributes({
            :sender => patient,
            :recipient => physician,
            :category => 'appointment_request_initiated'
          })
        end
      end

      context "when the appointment is accepted by the physician" do
        let!(:appointment) { FactoryGirl.create(:appointment) }

        it "should generate a notification object with category 'appointment_request_accepted'" do
          expect do
            appointment.accept!
          end
          .to change(Notification, :count).by(1)

          notification = Notification.first
          expect(notification).to have_attributes({
            :sender => appointment.physician,
            :recipient => appointment.patient,
            :category => 'appointment_request_accepted'
          })
        end
      end

      context "when the appointment is declined by the physician" do
        let!(:appointment) { FactoryGirl.create(:appointment) }

        it "should generate a notification object with category 'appointment_request_declined'" do
          expect do
            appointment.decline!
          end
          .to change(Notification, :count).by(1)

          notification = Notification.first
          expect(notification).to have_attributes({
            :sender => appointment.physician,
            :recipient => appointment.patient,
            :category => 'appointment_request_declined'
          })
        end
      end

      context "when the auto confirm option is true for the physician" do
        let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
        let!(:patient) { FactoryGirl.create(:user) }
        before do
          physician.appointment_preference.update(:auto_confirm => true)
        end

        it "should create two notifications for initiation and acceptance of the appointment request" do
          appointment = FactoryGirl.build(:appointment, :physician => physician, :patient => patient)
          expect do
            appointment.save
          end
          .to change(Notification, :count).by(2)

          initiation_notification = Notification.last
          acceptance_notification = Notification.first

          expect(initiation_notification).to have_attributes({
            :sender => patient,
            :recipient => physician,
            :category => 'appointment_request_initiated'
          })
          expect(acceptance_notification).to have_attributes({
            :sender => physician,
            :recipient => patient,
            :category => 'appointment_request_accepted'
          })

          expect(appointment.status).to eq('accepted')
        end
      end
    end
  end

  describe '#invalid appointment time' do
    context 'when the from_time is greater than the to_time' do
      let(:appointment) { FactoryGirl.build(:appointment, :from_time => 8000, :to_time => 4000) }

      it 'should not save the record and raise an error mmessage' do
        expect do
          appointment.save
        end.not_to change(Appointment, :count)

        expect(appointment.errors.full_messages).to include('Appointment timings are Invalid')
      end
    end
  end

end
