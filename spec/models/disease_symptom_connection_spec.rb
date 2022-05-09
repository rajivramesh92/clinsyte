require 'rails_helper'

RSpec.describe DiseaseSymptomConnection, type: :model do

  # Validations
  it { is_expected.to validate_presence_of(:disease) }
  it { is_expected.to validate_presence_of(:symptom) }

  it "should validate uniqueness on (disease_id, symptom_id) - Composite Key" do
    subject.disease = FactoryGirl.build(:disease)
    is_expected.to validate_uniqueness_of(:disease_id).scoped_to(:symptom_id)
  end

  # Associations
  it { is_expected.to belong_to(:disease) }
  it { is_expected.to belong_to(:symptom) }
  it { is_expected.to have_one(:patient) }
  it { is_expected.to have_many(:audits) }

  # Class Methods
  context '.activity_name' do
    it 'should return "Symptom"' do
      expect(described_class.activity_name).to eq('Symptom')
    end
  end

  describe '#get_activity_value_for' do
    context 'when a Symptom is created for a Disease' do
      let!(:disease) { FactoryGirl.create(:disease) }
      let!(:symptom) { FactoryGirl.create(:symptom) }
      let!(:disease_symptom_connection) { FactoryGirl.create(:disease_symptom_connection, :disease => disease, :symptom => symptom) }

      it 'should return the name of the Symptom' do
        expect(disease_symptom_connection.get_activity_value_for(disease_symptom_connection.audits.first)).to eq(symptom.name)
      end
    end

    context 'when a Symptom is updated for a Disease' do
      let!(:disease) { FactoryGirl.create(:disease) }
      let!(:symptom1) { FactoryGirl.create(:symptom) }
      let!(:symptom2) { FactoryGirl.create(:symptom, :name => 'symptom2') }
      let!(:disease_symptom_connection) { FactoryGirl.create(:disease_symptom_connection, :disease => disease, :symptom => symptom1) }

      before do
        disease_symptom_connection.update(:symptom => symptom2)
      end

      it 'should return the change with the previous and the new value' do
        expect(disease_symptom_connection.get_activity_value_for(disease_symptom_connection.audits.last)).to eq(:name => [symptom1.name, symptom2.name])
      end
    end

    context 'when a Symptom is removed for a Disease' do
      let!(:disease) { FactoryGirl.create(:disease) }
      let!(:symptom) { FactoryGirl.create(:symptom) }
      let!(:disease_symptom_connection) { FactoryGirl.create(:disease_symptom_connection, :disease => disease, :symptom => symptom) }

      before do
        disease_symptom_connection.destroy
      end

      it 'should return the name of the Symptom' do
        expect(disease_symptom_connection.get_activity_value_for(disease_symptom_connection.audits.first)).to eq(symptom.name)
      end
    end
  end

end
