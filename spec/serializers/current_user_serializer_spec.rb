describe CurrentUserSerializer do

  context 'when the user is a patient' do
    let(:patient) { FactoryGirl.create(:user) }

    context 'user has selected a physician' do
      let(:physician) { FactoryGirl.create(:user_with_physician_role) }

      before do
        patient.careteam.add_physician(physician)
      end

      it 'should render json including the current physician' do
        response_data = CurrentUserSerializer.new(patient).as_json

        expect(response_data).to include({
          :id => patient.id,
          :email => patient.email,
          :first_name => patient.first_name,
          :last_name => patient.last_name,
          :gender => patient.gender,
          :phone_number => patient.phone_number.to_s,
          :country_code => patient.country_code,
          :ethnicity => patient.ethnicity,
          :birthdate => patient.birthdate.to_time.strftime("%s%3N"),
          :uuid => patient.uuid,
          :role => patient.role.name,
          :license_id => patient.license_id,
          :expiry => patient.expiry,
          :name => patient.user_name,
          :phone_number_verified => patient.phone_number_verified?,
          :email_verified => patient.email_verified?,
          :current_physician => {
            :id => physician.id,
            :name => physician.user_name,
            :gender => physician.gender,
            :role => physician.role.name,
            :location => physician.location.capitalize,
            :status => !!patient.careteam.primary_physician,
            :icon => "pending",
            :admin => physician.admin?,
            :study_admin => physician.study_admin?
          }
        })
      end
    end

    context 'user has no selected physician' do
      it 'should render json without any current physician' do
        json = CurrentUserSerializer.new(patient).as_json

        expect(json).to include(:current_physician => nil)
      end
    end

    context 'user is not a patient' do
      let(:physician) { FactoryGirl.create(:user_with_physician_role) }

      it 'should render json without any current physician' do
        json = CurrentUserSerializer.new(physician).as_json
        expect(json[:role]).to eq(physician.role.name)
        expect(json).to include(:current_physician => nil)
      end
    end

  end
end
