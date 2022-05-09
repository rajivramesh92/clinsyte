describe EventIndependentSurveySubWorker do

  describe "perform" do

    context "when the job being processed gets failed due to some reason" do
      it "should retry the job for 3 more times" do
        expect(EventIndependentSurveySubWorker).to be_retryable 3
      end
    end

    context "when there is a failure during execution of the job" do
      it "should save and describe the error backtrace" do
        expect(EventIndependentSurveySubWorker).to save_backtrace
      end
    end

    context "when the jobs are pushed to the queue for processing" do
      it "should use the queue -> 'email' for it" do
        expect(EventIndependentSurveySubWorker).to be_processed_in :surveys
      end
    end

    context "when EventIndependentSurveySubWorker gets executed" do
      let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
      let!(:patient) { FactoryGirl.create(:user) }
      let!(:survey) { FactoryGirl.create(:survey) }

      it "should call the SurveyRequestSender service with appropriate parameters" do
        expect(SurveyRequestSender).to respond_to(:send)
        EventIndependentSurveySubWorker.perform_async(physician, patient.id, survey)
      end
    end

  end

end