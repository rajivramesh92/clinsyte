describe RoleSerializer, type: :serializer do

  # Tests for Role Serializer

  context 'when an object is displayed using Role serializer [example-1]' do
    let(:role) { Role.patient }

    it 'should render the role of the user' do
      expect(RoleSerializer.new(role).message).to include({
        :name => role.name
        })
    end
  end

  context 'when an object is displayed using Role serializer [example-2]' do
    let(:role) { Role.physician }

    it 'should render the role of the user' do
      expect(RoleSerializer.new(role).message).to include({
        :name => role.name
        })
    end
  end

end