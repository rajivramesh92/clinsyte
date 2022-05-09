describe DuplicationValidator do 

  context 'when the user attempts to sign up through unique email address and Phone Number' do
    it 'should create the user Account' do
      account = FactoryGirl.build(:user)
      DuplicationValidator.new(:fields => ['email', 'phone_number']).validate(account)
      expect(account.errors.full_messages).to be_empty
    end
  end

  context 'when the user attempts to sign up through duplicate email address assosiated to an Inactive account' do
    let(:user) { FactoryGirl.create(:user, :email => 'xyz@test.com') }
    before do
      user.inactive!
    end

    it 'should create the user Account' do
      account = FactoryGirl.build(:user, :email => user.email)
      DuplicationValidator.new({:fields => ['email']}).validate(account)
      expect(account.errors.full_messages).to be_empty
    end
  end

  context 'when the user attempts to sign up through duplicate Phone number assosiated to an Inactive account' do
    let(:user) { FactoryGirl.create(:user, :phone_number => 1234567890) }
    before do
      user.inactive!
    end

    it 'should create the user Account' do
      account = FactoryGirl.build(:user, :phone_number => user.phone_number)
      DuplicationValidator.new({:fields => ['phone_number']}).validate(account)
      expect(account.errors.full_messages).to be_empty
    end
  end

  context 'when the user attempts to sign up through duplicate email address assosiated to an Active account' do
    let(:user) { FactoryGirl.create(:user) }

    it 'should not be valid' do
      account = FactoryGirl.build(:user, :email => user.email)
      DuplicationValidator.new({:fields => ['email']}).validate(account)
      expect(account.errors.full_messages).to include('Email already exists')
    end
  end

  context 'when the user attempts to sign up through duplicate Phone number assosiated to an Active account' do
    let(:user) { FactoryGirl.create(:user, :phone_number => 1234567890) }

    it 'should not be valid' do
      account = FactoryGirl.build(:user, :email => 'xyz@test.com', :phone_number => user.phone_number)
      DuplicationValidator.new(:fields => ['phone_number']).validate(account)
      expect(account.errors.full_messages).to include('Phone number already exists')
    end
  end

  context 'when the user attempts to sign up through duplicate Phone number and Email assosiated to an Active account' do
    let(:user) { FactoryGirl.create(:user, :email => 'xyz@test.com', :phone_number => 1234567890) }

    it 'should not be valid' do
      account = FactoryGirl.build(:user, :email => user.email, :phone_number => user.phone_number)
      DuplicationValidator.new(:fields => ['email', 'phone_number']).validate(account)
      expect(account.errors.full_messages).to include('Email already exists')
      expect(account.errors.full_messages).to include('Phone number already exists')
    end
  end

end