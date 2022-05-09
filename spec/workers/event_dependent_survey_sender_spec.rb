describe EventDependentSurveySender do
  
  describe "perform" do
    context "when the job being processed gets failed due to some reason" do
      it "should retry the job for 3 more times" do
        expect(EventDependentSurveySender).to be_retryable 3
      end
    end

    context "when there is a failure during execution of the job" do
      it "should save and describe the error backtrace" do
        expect(EventDependentSurveySender).to save_backtrace
      end
    end

    context "when the jobs are pushed to the queue for processing" do
      it "should use the queue -> 'surveys' for it" do
        expect(EventDependentSurveySender).to be_processed_in :surveys
      end
    end

    context "when the jobs are queued to be processed" do
      let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
      let!(:survey) { FactoryGirl.create(:survey, :creator => physician) }
      let!(:patient) { FactoryGirl.create(:user) }

      it "should increase the queue size by 1" do
        expect do
          EventDependentSurveySender.perform_async(physician.id, [] << patient.id, survey.id)
        end.
        to change { EventDependentSurveySender.jobs.count }.by(1)
      end

      it "should trigger the assosiated method in the background" do
        expect_any_instance_of(SurveyRequestSender).to receive(:send).and_return(true)
        EventDependentSurveySender.new.perform(physician.id, [ patient.id ], survey.id)
      end
    end
  end

end