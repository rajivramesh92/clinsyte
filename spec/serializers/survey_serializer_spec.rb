describe SurveySerializer do

  context "when an object is displayed using Survey Serializer" do
    let!(:survey) { FactoryGirl.create(:survey) }
    let!(:question1) { FactoryGirl.create(:question, :survey => survey) }
    let!(:question2) { FactoryGirl.create(:question, :survey => survey, :type => 'MultipleChoiceQuestion') }
    let!(:choice1) { FactoryGirl.create(:choice, :question => question2) }
    let!(:choice2) { FactoryGirl.create(:choice, :question => question2) }
    let!(:question3) { FactoryGirl.create(:question, :survey => survey, :type => 'RangeBasedQuestion', :min_range => 1, :max_range => 10) }
    let!(:list) { FactoryGirl.create(:list) }
    let!(:option1) { FactoryGirl.create(:option, :list => list) }
    let!(:option2) { FactoryGirl.create(:option, :list => list) }
    let!(:question4) { FactoryGirl.create(:question, :survey => survey, :type => 'ListDrivenQuestion', :list => list) }

    it "should return the object using the attributes specified in the SurveySerilaizer" do
      expect(SurveySerializer.new(survey).as_json).to eq({
        :id => survey.id,
        :name => survey.name,
        :editable => survey.is_editable?,
        :treatment_plan_dependent => false,
        :questions => [
          {
            :id => question1.id,
            :description => question1.description,
            :category => 'descriptive',
            :attrs => []
          },
          {
            :id => question2.id,
            :description => question2.description,
            :category => 'multiple_choice',
            :attrs => [
              {
                :id => choice1.id,
                :option => choice1.option
              },
              {
                :id => choice2.id,
                :option => choice2.option
              }
            ]
          },
          {
            :id => question3.id,
            :description => question3.description,
            :category => 'range_based',
            :attrs => { :min => 1, :max => 10 }
          },
          {
            :id => question4.id,
            :description => question4.description,
            :category => "list_driven",
            :attrs => {
              :list => {
                :id => list.id,
                :name => list.name,
                :options => [
                  {
                    :id => option1.id,
                    :option => option1.name
                  },
                  {
                    :id => option2.id,
                    :option => option2.name
                  }
                ]
              },
              :category => nil
            }
          }
        ]
      })
    end
  end
end