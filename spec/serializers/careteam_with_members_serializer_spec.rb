describe CareteamWithMembersSerializer do

  context 'no member is present' do
    let!(:careteam) { FactoryGirl.create(:careteam) }

    it 'should return careteam details and the members as empty collection' do
      expect(CareteamWithMembersSerializer.new(careteam).as_json).to eq({
        :id => careteam.id,
        :patient => UserMinimalSerializer.new(careteam.patient).as_json,
        :members => []
      })
    end
  end

  context 'members are present' do
    let!(:careteam) { FactoryGirl.create(:careteam) }
    let!(:physician) { FactoryGirl.create(:user_with_physician_role) }

    before do
      careteam.add_member(physician)
    end

    it 'should return the members and careteam data' do
      expect(CareteamWithMembersSerializer.new(careteam).as_json).to eq({
        :id => careteam.id,
        :patient => UserMinimalSerializer.new(careteam.patient).as_json,
        :members => [
          UserMinimalSerializer.new(physician).as_json.merge!(:careteam_role => "primary")
        ]
      })
    end
  end

end