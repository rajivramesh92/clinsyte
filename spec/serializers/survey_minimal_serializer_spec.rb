describe SurveyMinimalSerializer do
  
  context "when an object is displayed using SurveyMinimalSerializer" do
    let!(:survey) { FactoryGirl.create(:survey) }

    it "should return the object using the attributes specified in the SurveyMinimalSerilaizer" do
      expect(SurveyMinimalSerializer.new(survey).as_json).to include({
        :id => survey.id,
        :name => survey.name,
        :status => survey.status
        }
      )
    end
  end
end