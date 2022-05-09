describe ReminderSenderWorker do
  
  describe "perform" do
    context "when the job being processed gets failed due to some reason" do
      it "should retry the job for 3 more times" do
        expect(ReminderSenderWorker).to be_retryable 3
      end
    end

    context "when there is a failure during execution of the job" do
      it "should save and describe the error backtrace" do
        expect(ReminderSenderWorker).to save_backtrace
      end
    end

    context "when the jobs are pushed to the queue for processing" do
      it "should use the queue -> 'email' for it" do
        expect(ReminderSenderWorker).to be_processed_in :reminders
      end
    end

    context "when the jobs are queued to be processed" do
      let!(:treatment_data) { FactoryGirl.create(:treatment_datum) }
      let(:params) do
        {
          :type => 'xyz',
          :data_id => treatment_data.id,
          :phone_number => '+918778365729'
        }
      end

      it "should increase the queue size by 1" do
        expect do
          ReminderSenderWorker.perform_async(params)
        end.
        to change { ReminderSenderWorker.jobs.count }.by(1)
      end

      it "should trigger the assosiated method in the background" do
        expect(TwilioMessageSender).to receive(:send_reminder).with(params[:phone_number] , treatment_data.treatment_plan_therapy.strain.name)
        expect(PrivatePub).to receive(:publish_to)

        ReminderSenderWorker.new.perform(params[:type], params[:data_id], params[:phone_number])
      end

    end
  end

end