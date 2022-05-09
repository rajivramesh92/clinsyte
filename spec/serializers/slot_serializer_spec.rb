describe SlotSerializer do

  context 'when an object is displayed using SlotSerializer' do
    let(:slot) { FactoryGirl.create(:slot) }

    it 'should display the object with attributes defined in SlotSerializer' do
      expect(SlotSerializer.new(slot).as_json).to include({
        :day => slot.day,
        :from_time => slot.from_time,
        :to_time => slot.to_time,
        :date => Date.today
      })
    end

  end

end