describe SuccessSerializer, type: :serializer do

  # Tests for Success Serializer

  context 'when an object is displayed using success serializer' do
    let(:resource) { FactoryGirl.create(:user) }

    it 'should render with success status and messages (if present)' do
      expect(SuccessSerializer.new(resource).as_json).to include({
        :status => 'success',
        :message => {}
        })
    end
  end

end