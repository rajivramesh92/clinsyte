require 'rails_helper'

RSpec.describe TreatmentPlanTherapy, type: :model do

  describe "Associations" do
    it { is_expected.to belong_to(:treatment_plan) }
    it { is_expected.to belong_to(:strain) }
    it { is_expected.to have_many(:dosage_frequencies).class_name(FieldValue) }
    it { is_expected.to have_many(:entity_connections).class_name(TherapyEntityConnection) }
    it { is_expected.to have_many(:treatment_data) }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:treatment_plan) }
    it { is_expected.to validate_presence_of(:strain) }
    it { is_expected.to validate_presence_of(:dosage_quantity) }
    it { is_expected.to validate_presence_of(:dosage_unit) }
    it { is_expected.to validate_presence_of(:intake_timing) }
  end

  # Instance Methods
  describe "#take_therapy" do
    let!(:treatment_plan) { FactoryGirl.create(:treatment_plan) }
    let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :dosage_frequencies_attributes => [{:name => 'n times a day', :value => 2}, {:name => "every n hours", :value => 1 }]) }

    context "when the patient attempts to take the therapy" do
      it "should update the intake_count and last_intake time accordingly" do
        treatment_plan_therapy.take_therapy

        expect(treatment_plan_therapy.treatment_data.last.intake_count).to eq(1)
        expect(treatment_plan_therapy.treatment_data.last.last_intake.to_i).to eq(DateTime.now.to_i)
      end
    end

    context "when the user has taken an overdose" do
      let!(:treatment_data) { FactoryGirl.create(:treatment_datum, :treatment_plan_therapy => treatment_plan_therapy, :intake_count => 3) }

      it "should notify the user about the overdose" do
        expect(treatment_plan_therapy.take_therapy).to eq(false)
      end

      it "should not set the reminder" do
        expect do
          treatment_plan_therapy.take_therapy
        end
        .to change { ReminderSenderWorker.jobs.count }.by(0)
      end
    end

    context "when the patient takes the therapy without overdose" do
      let!(:treatment_data) { FactoryGirl.create(:treatment_datum, :treatment_plan_therapy => treatment_plan_therapy, :intake_count => 0) }
      before do
        time_gap = treatment_plan_therapy.dosage_frequencies.find_by_name('every n hours')['value'].to_i rescue nil
        @time = time_gap.hours - ENV['REMINDER_TIME_GAP'].to_i * 60
      end

      it "should set the reminder for the next dosage" do
        expect do
          treatment_plan_therapy.take_therapy
        end
        .to change { ReminderSenderWorker.jobs.count }.by(1)
      end
    end
  end

  describe "#snooze_reminder?" do
    let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy) }

    context "when the user attempts to snooze the reminder" do
      let!(:treatment_data) { FactoryGirl.create(:treatment_datum, :treatment_plan_therapy => treatment_plan_therapy) }

      it "should schedule a job for reminder" do
        expect do
          treatment_plan_therapy.snooze_reminder
        end
        .to change { ReminderSenderWorker.jobs.count }.by(1)
      end
    end

    context "when the user attempts to snooze the reminder when dosage has not been taken yet" do
      it "should return false stating 'Reminder snoozing failed'" do
        expect do
          treatment_plan_therapy.snooze_reminder
        end
        .not_to change { ReminderSenderWorker.jobs.count }
      end
    end
  end

  describe "#schedule_reminder" do
    context "when all the parameters are correct" do
      let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy) }
      before do
        treatment_plan_therapy.take_therapy
      end

      it "should schedule the job for setting the reminder" do
        expect do
          treatment_plan_therapy.send(:schedule_reminder, 90, "dfee")
        end
        .to change { ReminderSenderWorker.jobs.count }.by(1)
      end
    end
  end

  describe "#Callback" do
    context "after validation" do
      context "when the user attempts to save therapy dosage frequency with valid combinations" do
        context "'n times a day' and 'as needed'" do
          let!(:treatment_plan_therapy) { FactoryGirl.build(:treatment_plan_therapy, :dosage_frequencies_attributes => [ {:name => "n times a day", :value => 2}, {:name => "as needed", :value => nil} ]) }

          it "should save the therapy dosages without raising errors" do
            expect(treatment_plan_therapy).to be_valid
          end
        end

        context "'n times a day' and 'every n hours'" do
          let!(:treatment_plan_therapy) { FactoryGirl.build(:treatment_plan_therapy, :dosage_frequencies_attributes => [ {:name => "n times a day", :value => 2}, {:name => "every n hours", :value => 2} ]) }

          it "should save the therapy dosages without raising errors" do
            expect(treatment_plan_therapy).to be_valid
          end
        end
      end

      context "when the user attempts to save the therapy with some invalid combinations" do
        let!(:treatment_plan_therapy) { FactoryGirl.build(:treatment_plan_therapy, :dosage_frequencies_attributes => [ {:name => "n times a day", :value => 2}, {:name => "no more than n times a day", :value => 2} ]) }
        context "'n times a day' and 'no more than n times a day'" do
          it "should not be valid" do

          treatment_plan_therapy.save
          expect(treatment_plan_therapy.errors.full_messages).to include("Dosage frequency combinations are Invalid")
          end
        end
      end
    end
  end

end
