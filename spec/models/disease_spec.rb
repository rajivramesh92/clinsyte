require 'rails_helper'

RSpec.describe Disease, type: :model do

  # Validation specs
  it { is_expected.to validate_presence_of(:condition) }
  it { is_expected.to validate_presence_of(:patient) }
  it { is_expected.to validate_presence_of(:diagnosis_date) }

  # Association specs
  it { is_expected.to belong_to(:patient) }
  it { is_expected.to belong_to(:condition) }
  it { is_expected.to have_many(:symptom_connections) }
  it { is_expected.to have_many(:medication_connections) }
  it { is_expected.to have_many(:symptoms).through(:symptom_connections) }
  it { is_expected.to have_many(:medications).through(:medication_connections) }
  it { is_expected.to have_many(:audits) }

  describe '#get_activity_value_for' do
    context 'when a disease is created' do
      let(:disease) { FactoryGirl.create(:disease) }

      it 'should return the name of the disease' do
        expect(disease.get_activity_value_for(disease.audits.last)).to eq(disease.name)
      end
    end

    context 'when the disease is updated' do
      let(:disease) { FactoryGirl.create(:disease) }
      let!(:disease_name) { disease.name }
      before do
        disease.update(:name => 'myDisease')
      end

      it 'should return the change with the previous and the new value' do
        expect(disease.get_activity_value_for(disease.audits.last)).to eq("condition" => [disease_name, disease.name])
      end
    end

    context 'when the disease is destroyed' do
      let(:disease) { FactoryGirl.create(:disease) }
      before do
        disease.destroy
      end

      it 'should return the name of the disease that is destroyed' do
        expect(disease.get_activity_value_for(disease.audits.first)).to eq(disease.name)
      end
    end
  end

end
