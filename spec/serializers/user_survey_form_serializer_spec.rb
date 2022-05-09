describe UserSurveyFormSerializer do

  context "when an object is renders using UserSurveyFormSerializer" do
    let!(:user_survey_form) { FactoryGirl.create(:user_survey_form) }

    it "should render the objects using the attributes defined in the UserSurveyFormSerializer" do
      expect(UserSurveyFormSerializer.new(user_survey_form).as_json).to include(
        {
          :id => user_survey_form.id,
          :survey => SurveyMinimalSerializer.new(user_survey_form.survey).as_json,
          :state => user_survey_form.state,
          :sender => {
            :id => user_survey_form.sender.id,
            :name => user_survey_form.sender.user_name,
            :gender => user_survey_form.sender.gender,
            :role => user_survey_form.sender.role.name,
            :location => user_survey_form.sender.location.capitalize,
            :admin => user_survey_form.sender.admin?,
            :study_admin => user_survey_form.sender.study_admin?
          },
          :receiver => {
            :id => user_survey_form.receiver.id,
            :name => user_survey_form.receiver.user_name,
            :gender => user_survey_form.receiver.gender,
            :role => user_survey_form.receiver.role.name,
            :location => user_survey_form.receiver.location.capitalize,
            :admin => user_survey_form.receiver.admin?,
            :study_admin => user_survey_form.receiver.study_admin?
          },
          :sent_at => user_survey_form.sent_at,
          :submitted_at => user_survey_form.submitted_at,
          :started_at => user_survey_form.started_at
        }
      )
    end
  end

end