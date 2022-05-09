describe NotificationService do

  describe '#notifications' do
    let(:physician) { FactoryGirl.create(:user_with_physician_role) }
    let(:patient1) { FactoryGirl.create(:user) }
    let(:patient2) { FactoryGirl.create(:user) }

    before do
      FactoryGirl.create_list(:notification, 10, :sender => patient1, :recipient => physician)
      FactoryGirl.create_list(:notification, 10, :sender => patient2, :recipient => physician, :status => 'seen')
    end

    context 'when the parameters passed are invalid' do
      it 'should return with an exception message' do
        expect do 
          NotificationService.new(nil , nil).notifications
        end.to raise_exception("Inputs are Invalid")
      end
    end

    context 'when the parameters are valid' do
      it 'should return all the groups present' do
        expect(NotificationService.new(physician).notifications.count).to eq(Notification.all.group_by(&:category).count)     
      end
    end

    context 'when user object is passed with no second parameter' do
      it 'should return all the unread notifications for the user' do
        expect(NotificationService.new(physician).notifications).to include(
          {
            :message => "You have received 10 care team membership invitations",
            :type => "careteam_request_initiated",
            :link => "/careteams/invites"
          }
        )
      end
    end

    context 'whent the second parameter is passed as true' do
      it 'should return all the notifications - read/unread for the user' do
        expect(NotificationService.new(physician, true).notifications).to include(
          {
            :message => "You have received 20 care team membership invitations",
            :type => "careteam_request_initiated",
            :link => "/careteams/invites"
          }         
        )
      end
    end

  end 
end