require 'rails_helper'

RSpec.describe Slot, type: :model do
  
  describe '#assosiations' do
    it { is_expected.to belong_to(:physician).class_name(:User) }
  end 

  describe 'Validations' do

    required_attributes = [
      :physician,
      :from_time,
      :to_time,
      :day,
    ]

    required_attributes.each do | attribute |
      it { is_expected.to validate_presence_of(attribute) }
    end

    context 'when the from_time is not in the range' do
      let(:physician) { FactoryGirl.create(:user_with_physician_role) }
      it 'should be invalid with error message "From time must be less than 86400"' do
        slot = FactoryGirl.build(:slot, :from_time => 1000000)
        expect(slot).not_to be_valid
        expect(slot.errors.full_messages).to include('From time must be less than 86400')
      end
    end

    context 'when the to_time is not in the range' do
      let(:physician) { FactoryGirl.create(:user_with_physician_role) }
      it 'should be invalid with error message "To time must be less than 86400"' do
        slot = FactoryGirl.build(:slot, :to_time => 1000000)
        expect(slot).not_to be_valid
        expect(slot.errors.full_messages).to include('To time must be less than 86400')
      end
    end

    context 'when the user is not a physician' do
      let(:patient) { FactoryGirl.create(:user) }
      it 'should be invalid with error message "Physician is Invalid"' do
        slot = FactoryGirl.build(:slot, :physician => patient)
        expect(slot).not_to be_valid
        expect(slot.errors.full_messages).to be_include('Physician is Invalid')
      end
    end

    context 'when the user attempts to create a slot with some overlapping time' do
      let!(:slot) { FactoryGirl.create(:slot, :from_time => 3600, :to_time => 7200) }

      it 'should not be valid' do
        slot1 = FactoryGirl.build(:slot, :physician => slot.physician, :from_time => 6000, :to_time => 8000)
        expect(slot1).not_to be_valid
        expect(slot1.errors.full_messages).to include('Slot already exists')
      end
    end

    context 'when the user attempts to create a slot with non-overlapping time' do
      let!(:slot) { FactoryGirl.create(:slot, :from_time => 3600, :to_time => 7200) }

      it 'should create the record' do
        FactoryGirl.build(:slot, :physician => slot.physician, :from_time => 7200, :to_time => 8000).should be_valid
      end
    end

    context 'when the user attempts to create a slot with overlapping time on some other day' do
      let!(:slot) { FactoryGirl.create(:slot, :from_time => 3600, :to_time => 7200, :day => 'tuesday') }
      it 'should create the record' do
        slot1 = FactoryGirl.build(:slot, :physician => slot.physician, :from_time => 6000, :to_time => 8000, :day => 'monday')
        expect(slot1).to be_valid
      end
    end

    context 'when the user attempts to create a slot from the 12am - 2am' do
      it 'should create the record' do
        FactoryGirl.build(:slot, :from_time => 0, :to_time => 7200).should be_valid
      end
    end

    context 'when the user attempts to create a slot from the 11pm - 12pm' do
      it 'should create the record' do
        FactoryGirl.build(:slot, :from_time => 82799, :to_time => 86399).should be_valid
      end
    end

  end
end
