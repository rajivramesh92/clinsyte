describe Request do
  describe 'Validations' do
    # Add required attributes here
    required_attributes = [
      :sender,
      :recipient
    ]

    required_attributes.each do | attribute |
      it { is_expected.to validate_presence_of(attribute) }
    end
  end

  describe 'Associations' do
    it { should belong_to(:sender).class_name(:User) }
    it { should belong_to(:recipient).class_name(:User) }
  end

  describe 'Callbacks' do
    describe 'create_notification' do
      context "when sender is a patient and recipient is a physician" do
        let(:sender) { FactoryGirl.create(:user) }
        let(:recipient) { FactoryGirl.create(:user_with_physician_role) }

        context 'when a request is created by a sender while choosing a recipient' do
          it "should create notification corresponding the request object" do
            expect do
              Request.create(sender: sender , recipient: recipient)
            end
            .to change(Notification, :count).by(1)

            notification = Notification.first
            expect(notification).to have_attributes({
              :sender => sender,
              :recipient => recipient,
              :category => 'careteam_request_initiated'
            })
          end
        end
      end

      context "when sender is a physician and recipient is a patient" do
        let(:sender) { FactoryGirl.create(:user_with_physician_role) }
        let(:recipient) { FactoryGirl.create(:user) }

        context 'when a request is created by a sender for the recipient' do
          it "should create notification corresponding the request object" do
            expect do
              Request.create(sender: sender , recipient: recipient)
            end
            .to change(Notification, :count).by(1)

            notification = Notification.first
            expect(notification).to have_attributes({
              :sender => sender,
              :recipient => recipient,
              :category => 'careteam_join_request_initiated'
            })
          end
        end
      end
    end
  end

  describe '.make_between' do

    context 'when no pending request exists for the given recipient and sender' do
      let(:sender) { FactoryGirl.create(:user) }
      let(:recipient) { FactoryGirl.create(:user_with_physician_role) }

      it "should create the request" do
        expect do
          Request.make_between(sender , recipient)
        end.to change(Request, :count).by(1)
      end
    end

    context 'when a pending request alredy exist for the given sender and recipient' do
      let(:sender) { FactoryGirl.create(:user) }
      let(:recipient) { FactoryGirl.create(:user_with_physician_role) }
      let!(:request) { FactoryGirl.create(:request, :sender => sender, :recipient => recipient) }

      it "should render error message stating 'Already invited'" do
        expect(Request.make_between(sender , recipient)).to eq('Already invited to the careteam')
      end
    end
  end

  describe 'add_to_careteam' do
    let(:sender) { FactoryGirl.create(:user) }
    let(:recipient) { FactoryGirl.create(:user_with_physician_role) }
    let!(:request) {   FactoryGirl.create(:request, :sender => sender, :recipient => recipient) }
    let!(:careteam) { sender.careteam }


    context 'when a request is accepted from pending' do
      before do
        request.accepted!
      end

      it "should add recipient to careteam" do
        expect(request).to be_accepted
        expect(careteam.reload.members).to include(recipient)
      end
    end


    context 'when a request is declined from pending' do
      before do
        request.declined!
      end

      it "should not add recipient to careteam" do
        expect(request).to be_declined
        expect(careteam.reload.members).not_to include(recipient)
      end
    end


    context 'when a request is accepted from declined' do
      before do
        request.declined!
        request.accepted!
      end

      it "should not add recipient to careteam" do
        expect(request).to be_accepted
        expect(careteam.reload.members).not_to include(recipient)
      end
    end
  end
end