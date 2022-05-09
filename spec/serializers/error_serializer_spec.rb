describe ErrorSerializer, type: :serializer do

	# Tests for Error Serializer

  context 'when an object is displayed using error serializer (with no errors)' do
    let(:resource) { FactoryGirl.create(:user) }

    it 'should render with error status and the errors (if present) ' do
    	expect(ErrorSerializer.new(resource).as_json).to include({
    		:status => 'error',
    		:errors => []
    		})
    end
  end

end