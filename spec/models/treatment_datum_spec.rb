require 'rails_helper'

RSpec.describe TreatmentDatum, type: :model do

  # Assosiations
  it { is_expected.to belong_to(:treatment_plan_therapy) }

  # Validations
  it { is_expected.to validate_presence_of(:treatment_plan_therapy) }

  # Instance Methods
  describe "#overdosage? and remindable?" do
    context "when the treatment plan therapy dosages include" do
      context "'n times a day' and 'every n hours'" do
        let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :dosage_frequencies_attributes => [{ :name => 'n times a day', :value => 2 }, { :name => 'every n hours', :value => 2 }]) }

        it_should_behave_like "overdosage?"
        it_should_behave_like "remindable?"
      end

      context "'n times a day' and 'every n hours'" do
        let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :dosage_frequencies_attributes => [{ :name => 'n times a day', :value => 2 }, { :name => 'as needed', :value => nil }]) }

        it_should_behave_like "overdosage?"
        it_should_behave_like "remindable?"
      end

      context "'no more than n times a day' and 'as needed'" do
        let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :dosage_frequencies_attributes => [{ :name => 'no more than n times a day', :value => 2 }, { :name => 'as needed', :value => nil }]) }

        it_should_behave_like "overdosage?"
        it_should_behave_like "remindable?"
      end

      context "'no more than n times a day' and 'as needed'" do
        let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :dosage_frequencies_attributes => [{ :name => 'no more than n times a day', :value => 2 }, { :name => 'as needed', :value => nil }, { :name => 'every n hours', :value => 2 }]) }

        it_should_behave_like "overdosage?"
        it_should_behave_like "remindable?"
      end

      context "'no more than n times a day' and 'as needed'" do
        let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :dosage_frequencies_attributes => [{ :name => 'no more than n times a day', :value => 2 }, { :name => 'every n hours', :value => 2 }]) }

        it_should_behave_like "overdosage?"
        it_should_behave_like "remindable?"
      end

      context "'every n hours' and 'as needed'" do
        let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :dosage_frequencies_attributes => [{ :name => 'as needed', :value => nil }, { :name => 'every n hours', :value => 2 }]) }

        context "when overdose has been taken" do
          let!(:treatment_data) { FactoryGirl.create(:treatment_datum, :treatment_plan_therapy => treatment_plan_therapy, :intake_count => 5) }

          it "should return false stating 'No overdose has been taken yet'" do
            expect(treatment_data.overdosage?).to be(false)
          end

          it "should return true stating 'Reminder needs to be set'" do
            expect(treatment_data.remindable?).to be(true)
          end
        end
      end
    end
  end

end
