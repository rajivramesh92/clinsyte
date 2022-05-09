describe EmailWorker do

  # Test for email worker

  describe '#perform' do

    context "when the job being processed gets failed due to some reason" do
      it "should retry the job for 3 more times" do
        expect(EmailWorker).to be_retryable 3
      end
    end

    context "when there is a failure during execution of the job" do
      it "should save and describe the error backtrace" do
        expect(EmailWorker).to save_backtrace
      end
    end

    context "when the jobs are pushed to the queue for processing" do
      it "should use the queue -> 'email' for it" do
        expect(EmailWorker).to be_processed_in :email
      end
    end

    context "when the jobs are queued to be processed" do

      let!(:user) { FactoryGirl.create(:user) }
      let(:params) do
        {
          :emailer_class => 'UserMailer',
          :method => 'send_verification_token_email',
          :arguments => user
        }
      end

      it "should increase the queue size by 1" do
        expect do
          EmailWorker.perform_async(params)
        end.
        to change { EmailWorker.jobs.count }.by(1)
      end
    end

    context "when the job is added to the queue for processing" do

      let(:user) { FactoryGirl.create(:user) }
      let(:params) do
        {
          :emailer_class => 'UserMailer',
          :method => 'send_verification_token_email',
          :arguments => user.id
        }
      end

      it "should trigger the assosiated method in the background" do
        expect_any_instance_of(UserMailer).to receive(:send_verification_token_email).with(user.id)
        EmailWorker.new.perform(params)
      end
    end

  end
end 