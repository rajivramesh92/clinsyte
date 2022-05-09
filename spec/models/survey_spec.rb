require 'rails_helper'

RSpec.describe Survey, type: :model do

  # Assosiations
  it { is_expected.to belong_to(:creator).class_name(:User) }
  it { is_expected.to have_many(:questions) }
  it { is_expected.to have_many(:user_survey_forms) }
  it { is_expected.to have_many(:survey_configurations) }
  it { is_expected.to have_many(:answers).through(:questions) }

  # Validations
  it { is_expected.to validate_presence_of(:creator) }
  it { is_expected.to validate_presence_of(:name) }

  # Instance Method
  describe ".created_by_admin" do
    let(:admin) { FactoryGirl.create(:user_with_admin_role) }
    let(:support) { FactoryGirl.create(:user_with_support_role) }

    let!(:survey_with_physicians) { FactoryGirl.create_list(:survey, 2) }
    let!(:survey_with_admin) { FactoryGirl.create_list(:survey, 2, :creator => admin) }
    let!(:survey_with_study_admin) { FactoryGirl.create_list(:survey, 2, :creator => support) }

    before do
      support.study_admin!
    end

    it "should return all the surveys created by Admin user only" do
      surveys = Survey.created_by_admin
      expect(surveys.map &:id).to match_array(survey_with_admin.map &:id)
    end
  end

  describe ".created_by_study_admin" do
    let(:admin) { FactoryGirl.create(:user_with_admin_role) }
    let(:support) { FactoryGirl.create(:user_with_support_role) }

    let!(:survey_with_physicians) { FactoryGirl.create_list(:survey, 2) }
    let!(:survey_with_admin) { FactoryGirl.create_list(:survey, 2, :creator => admin) }
    let!(:survey_with_study_admin) { FactoryGirl.create_list(:survey, 2, :creator => support) }

    before do
      support.study_admin!
    end

    it "should return all the surveys created by Study Admin user only" do
      surveys = Survey.created_by_study_admin
      expect(surveys.map &:id).to match_array(survey_with_study_admin.map &:id)
    end
  end

end
