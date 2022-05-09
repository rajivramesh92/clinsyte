describe UserSerializer do

  # Tests for User Seializer

  context 'when an object is displayed using UserSerializer' do
    let(:resource) { FactoryGirl.create(:user) }

    it 'should render the object with the attributes specified in the Users Controllers' do
      expect(UserSerializer.new(resource).as_json).to include({
        :email => resource.email,
        :first_name => resource.first_name,
        :last_name => resource.last_name,
        :gender => resource.gender,
        :phone_number => resource.phone_number.to_s,
        :country_code => resource.country_code,
        :ethnicity => resource.ethnicity,
        :birthdate => resource.birthdate.to_time.strftime("%s%3N"),
        :role => resource.role.name,
        :admin => resource.admin?,
        :study_admin => resource.study_admin?
      })
    end
  end

  context 'when the object being displayed using UserSerializer have some invalid data' do
    let(:resource) { FactoryGirl.create(:user) }

    it 'should display the data as it is without breaking the code' do
      resource.email = nil
      resource.phone_number = nil
      resource.birthdate = nil
      expect(UserSerializer.new(resource).as_json).to include({
        :email => nil,
        :first_name => resource.first_name,
        :last_name => resource.last_name,
        :gender => resource.gender,
        :phone_number => nil,
        :country_code => resource.country_code,
        :ethnicity => resource.ethnicity,
        :birthdate => nil,
        :role => resource.role.name,
        :admin => resource.admin?,
        :study_admin => resource.study_admin?
      })
    end
  end
end