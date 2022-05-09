describe VerificationCodeSender do

	# Test for email worker

	describe '#perform' do

		context "when the job being processed gets failed due to some reason" do
			it "should retry the job for 1 more times" do
				expect(VerificationCodeSender).to be_retryable 1
			end
		end

		context "when there is a failure during execution of the job" do
			it "should save and describe the error backtrace" do
				expect(VerificationCodeSender).to save_backtrace
			end
		end

		context "when the jobs are pushed to the queue for processing" do
			it "should use the queue -> 'sms' for it" do
				expect(VerificationCodeSender).to be_processed_in :sms
			end
		end

		context "when the jobs are queued to be processed" do

			let(:params) do
				{
					:to => 7667254618,
					:verification_code => '12345678'
				}
			end

			it "should increase the queue size by 1" do
				expect do
		    	VerificationCodeSender.perform_async(params)
		    end.
		    to change { VerificationCodeSender.jobs.count }.by(1)
			end
		end

		context "when the job is added to the queue for processing" do

			let(:params) do
				{
					:to => 7667254008,
					:verification_code => '12345675'
				}
			end

			before do
				Twilio::REST::Client.stub(:new).and_return(OpenStruct.new)
			end

			it "should trigger the assosiated method in the background" do
				expect(TwilioMessageSender).to receive(:send_verification_code).with(params[:to] , params[:verification_code])
				VerificationCodeSender.new.perform(params)
			end
		end

	end
end 