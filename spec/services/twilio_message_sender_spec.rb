describe TwilioMessageSender do

  describe ".send_verification_code" do

    context "params are present" do
      context "params are valid" do
        before do
          Twilio::REST::Messages.any_instance.stub(:create).and_return(true)
        end

        it "should SMS and return 'true'" do
          expect(described_class.send_verification_code('+913654535525', 123345)).to eq(true)
        end
      end

      context "params are invalid" do
        before do
          Twilio::REST::Messages.any_instance.stub(:create).and_return(false)
        end

        it "should not send SMS and return 'false'" do
          expect(described_class.send_verification_code("something", "test")).to eq(false)
        end
      end
    end

    context "params are null" do
      before do
        Twilio::REST::Messages.any_instance.stub(:create) do
          raise StandardError.new("'To' address required")
        end
      end

      it "should raise exception" do
        expect do
          described_class.send_verification_code(nil, nil)
        end.
        to raise_exception("'To' address required")
      end
    end

  end

  describe ".send_reminder" do

    context "when params are present" do
      context "when params are valid" do
        before do
          Twilio::REST::Messages.any_instance.stub(:create).and_return(true)
        end

        it "should SMS and return 'true'" do
          expect(described_class.send_reminder('+913654535525', 'Therapy1')).to eq(true)
        end
      end

      context "params are invalid" do
        before do
          Twilio::REST::Messages.any_instance.stub(:create).and_return(false)
        end

        it "should not send SMS and return 'false'" do
          expect(described_class.send_verification_code("something", "test")).to eq(false)
        end
      end

      context "params are null" do
        before do
          Twilio::REST::Messages.any_instance.stub(:create) do
            raise StandardError.new("'To' address required")
          end
        end

        it "should raise exception" do
          expect do
            described_class.send_verification_code(nil, nil)
          end.
          to raise_exception("'To' address required")
        end
      end
    end
  end

end