require 'rails_helper'

RSpec.describe DiseaseMedicationConnection, type: :model do

  # Validations
  it { is_expected.to validate_presence_of(:disease) }
  it { is_expected.to validate_presence_of(:medication) }

  it "should validate uniqueness on (disease_id, medication_id) - Composite Key" do
    subject.disease = FactoryGirl.build(:disease)
    is_expected.to validate_uniqueness_of(:disease_id).scoped_to(:medication_id)
  end

  # Associations
  it { is_expected.to belong_to(:disease) }
  it { is_expected.to belong_to(:medication) }
  it { is_expected.to have_one(:patient) }
  it { is_expected.to have_many(:audits) }

  # Class Methods
  describe '.activity_name' do
    it 'should return "Medication"' do
      expect(described_class.activity_name).to eq('Medication')
    end
  end

  #Instance Methods
  describe '#get_activity_value_for' do
    context 'when a Medication is added for a Disease' do
      let!(:disease) { FactoryGirl.create(:disease) }
      let!(:medication) { FactoryGirl.create(:medication) }
      let!(:disease_medication_connection) { FactoryGirl.create(:disease_medication_connection, :disease => disease, :medication => medication) }

      it 'should return the name of the Medication' do
        expect(disease_medication_connection.get_activity_value_for(disease_medication_connection.audits.first)).to eq(medication.name)
      end
    end

    context 'when a Medication is updated for a Disease' do
      let!(:disease) { FactoryGirl.create(:disease) }
      let!(:medication1) { FactoryGirl.create(:medication) }
      let!(:medication2) { FactoryGirl.create(:medication, :name => 'medication2') }
      let!(:disease_medication_connection) { FactoryGirl.create(:disease_medication_connection, :disease => disease, :medication => medication1) }

      before do
        disease_medication_connection.update(:medication => medication2)
      end

      it 'should return the change with the previous and the new value' do
        expect(disease_medication_connection.get_activity_value_for(disease_medication_connection.audits.last)).to include({
          :name => [medication1.name, medication2.name],
          :description => [medication1.description, medication2.description]
        })
      end
    end

    context 'when a Medication is removed for a Disease' do
      let!(:disease) { FactoryGirl.create(:disease) }
      let!(:medication) { FactoryGirl.create(:medication) }
      let!(:disease_medication_connection) { FactoryGirl.create(:disease_medication_connection, :disease => disease, :medication => medication) }

      before do
        disease_medication_connection.destroy
      end

      it 'should return the name of the Medication' do
        expect(disease_medication_connection.get_activity_value_for(disease_medication_connection.audits.first)).to eq(medication.name)
      end
    end
  end

end
