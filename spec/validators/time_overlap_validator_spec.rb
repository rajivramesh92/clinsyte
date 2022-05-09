describe TimeOverlapValidator do 

  context 'when a slot is created with non-overlapping time' do
    let!(:slot1) { FactoryGirl.create(:slot, :from_time => 3000.0, :to_time => 5000.0) }
    it 'should be a valid record' do
      slot = FactoryGirl.build(:slot, :physician => slot1.physician, :from_time => 7200, :to_time => 8000)
      TimeOverlapValidator.new.validate(slot)
      expect(slot.errors.full_messages).to be_empty
    end
  end

  context 'when a slot is created with the overlapping time' do
    let!(:slot1) { FactoryGirl.create(:slot, :from_time => 3000.0, :to_time => 5000.0) }
    it 'should be an invalid record' do
      slot = FactoryGirl.build(:slot, :physician => slot1.physician, :from_time => 4000.0, :to_time => 6000.0)
      TimeOverlapValidator.new.validate(slot)
      expect(slot.errors.full_messages).to include('Slot already exists')
    end
  end

  context 'when the object contains some invalid values' do
    let!(:slot1) { FactoryGirl.create(:slot, :from_time => 3000.0, :to_time => 5000.0) }
    context 'when the from_time is passed as nil' do
      it 'should not raise any exception' do
        slot = FactoryGirl.build(:slot, :from_time => nil)
        expect do
          TimeOverlapValidator.new.validate(slot)
        end
        .not_to raise_exception

         expect(slot.errors.full_messages).to be_empty
      end
    end

    context 'when the from_time passed is less than 0' do
      it 'should not raise any exception' do
        slot = FactoryGirl.build(:slot, :from_time => -100)
        expect do
          TimeOverlapValidator.new.validate(slot)
        end
        .not_to raise_exception

         expect(slot.errors.full_messages).to be_empty
      end
    end

    context 'when the day is passed as nil' do
      it 'should not raise any exception' do
        slot = FactoryGirl.build(:slot, :day => nil)
        expect do
          TimeOverlapValidator.new.validate(slot)
        end
        .not_to raise_exception

         expect(slot.errors.full_messages).to be_empty
      end
    end

  end

end