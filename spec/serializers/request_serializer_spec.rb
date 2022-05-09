describe RequestSerializer do
  let(:patient) { FactoryGirl.create(:user) }
  let(:physician) { FactoryGirl.create(:user_with_physician_role) }
  let(:careteam_request) {FactoryGirl.create(:request, :sender => patient)}

  context 'when all parameters in request serializer are correct' do
    it 'should return the json'do
      expect(RequestSerializer.new(careteam_request).as_json).to include({
        :id => careteam_request.id,
        :sender => UserMinimalSerializer.new(careteam_request.sender).as_json,
        :recipient => UserMinimalSerializer.new(careteam_request.recipient).as_json,
        :status => "pending"
      })
    end
  end

  context 'sender is invalid' do
    before do
      careteam_request.sender_id = -1
    end

    it 'should return recipient as "null"'do
      expect(RequestSerializer.new(careteam_request).as_json).to include({
        :id => careteam_request.id,
        :sender => nil,
        :recipient => UserMinimalSerializer.new(careteam_request.recipient).as_json,
        :status => "pending"
      })
    end
  end

  context 'recipient is invalid' do
    before do
      careteam_request.recipient_id = -1
    end

    it 'should return recipient as "null"'do
      expect(RequestSerializer.new(careteam_request).as_json).to include({
        :id => careteam_request.id,
        :sender => UserMinimalSerializer.new(careteam_request.sender).as_json,
        :recipient => nil,
        :status => "pending"
      })
    end
  end
end
