describe User do

  # Add required attributes here
  required_attributes = [
    :email,
    :first_name,
    :last_name,
    :gender,
    :ethnicity,
    :phone_number,
    :country_code
  ]

  required_attributes.each do | attribute |
    it { is_expected.to validate_presence_of(attribute) }
  end

  # Custom and Other validations
  it { is_expected.to validate_length_of(:email).is_at_most(255) }
  it { is_expected.to allow_value("sample-user@example.com").for(:email) }
  it { is_expected.not_to allow_value("sample-user").for(:email) }
  it { is_expected.to validate_length_of(:country_code).is_at_least(1).is_at_most(5) }

  describe '#phone number' do
    context 'when the phone number is less than 5 digits' do
      it 'should not be valid' do
        user = FactoryGirl.build(:user, :phone_number => 1234)
        expect(user).not_to be_valid
      end
    end

    context 'when the phone number is between 5 to 15 digits' do
      it 'should be valid' do
        user = FactoryGirl.build(:user, :phone_number => 12345678)
        expect(user).to be_valid
      end
    end

    context 'when the phone number is greater than 15 digits' do
      it 'should not be valid' do
        user = FactoryGirl.build(:user, :phone_number => 12345678910111324345)
        expect(user).not_to be_valid
      end
    end

    context 'when the phone number does not consisits of digits' do
      it 'should not be valid' do
        user = FactoryGirl.build(:user, :phone_number => '111df324345')
        expect(user).not_to be_valid
      end
    end
  end

  # Association specs
  it { is_expected.to have_one(:role).through(:user_role) }
  it { is_expected.to have_many(:careteam_memberships).with_foreign_key(:member_id) }
  it { is_expected.to have_many(:careteams).through(:careteam_memberships) }
  it { is_expected.to have_many(:sent_notifications) }
  it { is_expected.to have_many(:received_notifications) }
  it { is_expected.to have_many(:genetics) }
  it { is_expected.to have_many(:diseases) }
  it { is_expected.to have_many(:symptoms).through(:diseases) }
  it { is_expected.to have_many(:conditions).through(:diseases) }
  it { is_expected.to have_many(:medications).through(:diseases) }
  it { is_expected.to have_many(:audits) }
  it { is_expected.to have_many(:associated_audits) }
  it { is_expected.to have_many(:received_surveys) }
  it { is_expected.to have_many(:sent_surveys) }
  it { is_expected.to have_many(:surveys) }
  it { is_expected.to have_many(:answers) }

  # Testcases for birthdate validation
  describe "#birthdate_is_valid?" do

    it "should require birthdate to be set" do
      user = User.create
      expect(user.errors.full_messages).to be_include("Birthdate can't be blank")
    end

    it "should require valid date for birthdate" do
      valid_dob_user = User.create(:birthdate => "01/06/2022")
      expect(valid_dob_user.errors[:birthdate]).not_to be_present

      invalid_dob_user = User.create(:birthdate => "something")
      expect(invalid_dob_user.errors.full_messages).to be_include("Birthdate must be a valid date")
    end
  end

  # Testcases for instance methods
  describe "#set_default_role" do
    let(:user) { FactoryGirl.create(:user) }

    it { expect(user).to be_patient }
  end

  describe "#all_audits" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:disease) { FactoryGirl.create(:disease, :patient => user) }

    it "should return audits of user and it's associations" do
      expect(user.all_audits.map(&:auditable_type)).to include("Disease")
    end
  end

  describe "#user_name" do
    context "when no first_name and last_name is present" do
      let!(:user) {
        FactoryGirl.build(:user, {
          :first_name => nil,
          :last_name => nil
        })
      }

      it "should return 'User'" do
        expect(user.user_name).to eq("User")
      end
    end

    context "when the role is physician" do
      let!(:physician) {
        FactoryGirl.create(:user_with_physician_role, {
          :first_name => "some",
          :last_name => "thing"
        })
      }

      it "should return the concatenation of first and last names with 'Dr.'" do
        expect(physician.user_name).to eq("Dr. some thing")
      end
    end

    context "when the role is neither patient nor physician" do
      let!(:user) {
        FactoryGirl.build(:user, {
          :first_name => "some",
          :last_name => "thing",
          :role => :admin
        })
      }

      it "should return the concatenation of first and last names" do
        expect(user.user_name).to eq("some thing")
      end
    end
  end

  describe "#create_appointment_preference" do
    context "when a user is created with physician role" do
      it "should create an appointment preference for the user" do
        physician = FactoryGirl.build(:user_with_physician_role)
        expect do
          physician.save
        end
        .to change(AppointmentPreference, :count).by(1)

        expect(AppointmentPreference.last).to have_attributes({
          :physician => physician,
          :auto_confirm => false
        })
      end
    end

    context "when a user is created with patient role" do
      it "should not create an appointment preference for the user" do
        patient = FactoryGirl.build(:user)
        expect do
          patient.save
        end
        .not_to change(AppointmentPreference, :count)
      end
    end
  end

  describe "#formatted_phone_number" do
    context 'country_code and phone_number is nil' do
      it 'should render \'\'' do
        expect(User.new.formatted_phone_number).to eq('')
      end
    end

    context 'country_code and phone_number is present' do
      let(:user) { FactoryGirl.build(:user) }

      it 'should append plus with country_code and phone_number' do
        expect(user.formatted_phone_number).to eq("+#{user.country_code}#{user.phone_number}")
      end
    end
  end

  # Testcases for class methods
  describe '.with' do
    context 'valid data is passed' do
      context 'when single role is passed' do
        let!(:patient_records) { FactoryGirl.create_list(:user, 20) }
        let!(:patient_role) { "patient" }

        it 'should return all the users with the given role' do
          users = User.with(patient_role)
          expect(users).to match_array(patient_records)
        end
      end

      context 'when multiple roles are passed' do
        let!(:physician_records) { FactoryGirl.create_list(:user_with_physician_role, 25) }
        let!(:physician_and_admin_role) { [ "physician", "admin" ] }

        it 'should return all the users with the given roles' do
          users = User.with(physician_and_admin_role)
          physicians = User.physicians
          admins = User.joins(:role).where("roles.name ilike 'admin'")
          expect(users).to match_array(physicians + admins)
        end
      end
    end

    context 'invalid data is passed' do
      it 'should return empty collection' do
        expect(User.with(User.first)).to be_empty
      end
    end
  end

  describe "#has_pending_tpd_surveys?" do
    context "when a user with physician role tries to detect if he has some sent pending TPD surveys" do
      let!(:user) { FactoryGirl.create(:user) }
      let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
      let!(:tpd_survey) { FactoryGirl.create(:survey, :treatment_plan_dependent => true, :creator => physician) }
      let!(:normal_survey) { FactoryGirl.create(:survey, :creator => physician) }
      let!(:tpd_survey_request) { FactoryGirl.create(:user_survey_form, :survey => tpd_survey, :sender => physician, :receiver => user, :state => 'pending') }
      let!(:normal_survey_request) { FactoryGirl.create(:user_survey_form, :survey => normal_survey, :sender => physician, :receiver => user, :state => 'pending') }

      it "should notify true or false based on unresponded TPD Surveys" do
        expect(user.has_pending_tpd_surveys?).to eq(true)
      end
    end

    context "when a user with patient role tries to detect if he has some received pending TPD surveys" do
      let!(:user) { FactoryGirl.create(:user) }
      let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
      let!(:tpd_survey) { FactoryGirl.create(:survey, :treatment_plan_dependent => true, :creator => physician) }
      let!(:normal_survey) { FactoryGirl.create(:survey, :creator => physician) }
      let!(:tpd_survey_request) { FactoryGirl.create(:user_survey_form, :survey => tpd_survey, :sender => physician, :receiver => user, :state => 'pending') }
      let!(:normal_survey_request) { FactoryGirl.create(:user_survey_form, :survey => normal_survey, :sender => physician, :receiver => user, :state => 'pending') }

      it "should notify true or false based on unresponded TPD Surveys" do
        expect(user.has_pending_tpd_surveys?).to eq(true)
      end
    end

    context "when a user with some other role attempts to access thiss method" do
      let!(:admin) { FactoryGirl.create(:user_with_admin_role) }
  
      it "should notify true or false based on unresponded TPD Surveys" do
        expect do
          admin.has_pending_tpd_surveys?
        end
        .to raise_exception('Needs to be a Patient or a Physician')
      end
    end
  end

end
