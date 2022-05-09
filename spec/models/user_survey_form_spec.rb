require 'rails_helper'

RSpec.describe UserSurveyForm, type: :model do

  # Assosiations
  it { is_expected.to belong_to(:survey) }
  it { is_expected.to belong_to(:sender).class_name('User') }
  it { is_expected.to belong_to(:receiver).class_name('User') }

  # Validations
  it { is_expected.to validate_presence_of(:survey) }
  it { is_expected.to validate_presence_of(:sender) }
  it { is_expected.to validate_presence_of(:receiver) }

  # Callbacks
  describe '#after_create' do
    context "when the survey request is created from the physician to the patient" do
      let(:user_survey_form) { FactoryGirl.build(:user_survey_form) }

      it "should create a Notification corresponding to the Survey Object" do
        expect do
          user_survey_form.save
        end
        .to change(Notification, :count).by(1)

        notification = Notification.last
        expect(notification).to have_attributes({
            :sender => user_survey_form.sender,
            :recipient => user_survey_form.receiver,
            :category => 'survey_request_initiated'
          }
        )
      end
    end
  end

  describe "#after_initialize" do
    context "when the survey request is created" do
      before do
        Timecop.freeze(Time.zone.now)
      end

      it "should have the status as pending and sent_time as current time" do
        expect(UserSurveyForm.new).to have_attributes({
          :sent_at => Time.zone.now,
          :state => 'pending'
        })
      end
    end
  end

  # States
  describe "states" do
    let!(:user_survey_form) { FactoryGirl.create(:user_survey_form) }

    context "when a Survey Request is created" do
      it "should have the initial state as 'pending'" do
        should be_pending
      end
    end

    context "when the :start event is triggered" do
      it "should change the state from 'pending' to 'started'" do
        expect do
          user_survey_form.start
        end
        .to change(user_survey_form, :state).from('pending').to('started')
      end

      it "should touch started_at" do
        user_survey_form.start
        expect(user_survey_form.reload.started_at.to_i).to eq(Time.zone.now.to_i)
      end
    end

    context "when the :submit event is triggered" do
      before do
        user_survey_form.start
      end
      it "should change the state from 'started' to 'submitted'" do
        expect do
          user_survey_form.submit
        end
        .to change(user_survey_form, :state).from('started').to('submitted')
      end

      it "should touch submitted_at" do
        user_survey_form.submit
        expect(user_survey_form.reload.submitted_at.to_i).to eq(Time.zone.now.to_i)
      end
    end
  end

  describe 'delegate' do
    describe 'treatment_plan_dependent' do
      let!(:tpd_survey) { FactoryGirl.create(:survey, :treatment_plan_dependent => true) }
      let!(:user_survey_form) { FactoryGirl.create(:user_survey_form, :survey => tpd_survey) }

      context "when is_tpd_survey_request? is called on an UserSurveyForm instance" do
        it "should return true or false based on the survey typpe the request is for" do
          expect(user_survey_form.treatment_plan_dependent).to eq(true)
        end
      end
    end
  end

  describe 'scopes' do
    describe 'pending' do
      let!(:user) { FactoryGirl.create(:user) }
      let!(:pending_user_survey_requests) { FactoryGirl.create_list(:user_survey_form, 10, :state => 'pending', :receiver => user) }
      let!(:started_user_survey_requests) { FactoryGirl.create_list(:user_survey_form, 10, :state => 'started', :receiver => user) }
      let!(:submitted_user_survey_requests) { FactoryGirl.create_list(:user_survey_form, 10, :state => 'submitted', :receiver => user) }

      context "when this scope is called on the user_survey_form ActiveRecordRelation" do
        it "should return requests with only pending and started state" do
          expect(user.received_surveys.pending).to be_all { |request| request.pending? or request.started? }
        end
      end
    end

    describe 'tpd' do
      let!(:user) { FactoryGirl.create(:user) }
      let!(:tpd_survey) { FactoryGirl.create(:survey, :treatment_plan_dependent => true) }
      let!(:normal_survey) { FactoryGirl.create(:survey) }

      let!(:tpd_survey_request) { FactoryGirl.create(:user_survey_form, :survey => tpd_survey, :receiver => user) }
      let!(:normal_survey_request) { FactoryGirl.create(:user_survey_form, :survey => normal_survey, :receiver => user) }

      context "when this scope is called on user_survey_form ActiveRecordRelation" do
        it "should return requests only for Treatment Plan Dependent Surveys" do
          expect(user.received_surveys.tpd).to be_all { |request| request.treatment_plan_dependent }
        end
      end
    end
  end
end
