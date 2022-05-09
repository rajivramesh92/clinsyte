require 'rails_helper'

RSpec.describe SurveyConfiguration, type: :model do

  # Assosiations
  it { is_expected.to belong_to(:survey) }
  it { is_expected.to belong_to(:sender) }

  # Validations
  it { is_expected.to validate_presence_of(:survey) }
  it { is_expected.to validate_presence_of(:sender) }
  it { is_expected.to validate_presence_of(:from_date) }
  it { is_expected.to validate_presence_of(:days) }

  describe "scope" do
    describe "eligible_to_validate" do
      let!(:survey_configuration1) { FactoryGirl.create(:survey_configuration, :from_date => Date.today) }
      let!(:survey_configuration2) { FactoryGirl.create(:survey_configuration, :from_date => Date.today - 2) }
      let!(:survey_configuration3) { FactoryGirl.create(:survey_configuration, :from_date => Date.today + 3 ) }

      it "should return all the survey_configuration having from date <= current_date" do
        response = SurveyConfiguration.eligible_to_validate
        expect(response).to be_all { |survey_config| survey_config.from_date <= Time.now.utc.to_date}
      end
    end
  end

  describe "Instance methods" do
    describe ".update_last_acknowledged" do
      let!(:survey_configuration) { FactoryGirl.create(:survey_configuration) }

      context "when this function is invoked for a survey configuration instance" do
        it "must update the last_acknowledged attribute with the current DateTime" do
          Timecop.freeze(DateTime.now) do
            survey_configuration.update_last_acknowledged
            expect(survey_configuration.reload.last_acknowledged.to_date).to eq(Time.now.utc.to_date)
          end
        end
      end
    end

    describe ".eligible_to_send?" do
      let!(:survey_configuration1) { FactoryGirl.create(:survey_configuration, :from_date => Date.today) }
      let!(:survey_configuration2) { FactoryGirl.create(:survey_configuration, :from_date => Date.today - 2) }
      let!(:survey_configuration3) { FactoryGirl.create(:survey_configuration, :from_date => Date.today + 3 ) }

      context "when last_acknowledged is nil" do
        it "should return true or false based on from_date is equal to current utc date or not" do
          expect(survey_configuration1.eligible_to_send?).to eq(true)
          expect(survey_configuration2.eligible_to_send?).to eq(false)
          expect(survey_configuration3.eligible_to_send?).to eq(false)
        end
      end

      context "when last_acknowledged has some date value" do
        let!(:survey_configuration1) { FactoryGirl.create(:survey_configuration, :from_date => Date.today-6, :last_acknowledged => DateTime.now - 2, :days => 2) }
        let!(:survey_configuration2) { FactoryGirl.create(:survey_configuration, :from_date => Date.today-5, :last_acknowledged => DateTime.now - 2, :days => 3) }

        it "should return true" do
          expect(survey_configuration1.eligible_to_send?).to eq(true)
        end

        it "should return false" do
          expect(survey_configuration2.eligible_to_send?).to eq(false)
        end
      end
    end
  end

end
