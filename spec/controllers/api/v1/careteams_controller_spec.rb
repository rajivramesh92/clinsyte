describe Api::V1::CareteamsController do

  describe '#remove_member' do
    context "when the user is not logged in" do
      it "should return error 'Authorized users only'" do
        post :remove_member, :id => 1

        expect_unauthorized_access
        expect_json_content
        expect(json['errors']).to include("Authorized users only.")
      end
    end

    context "when the user is logged in as a physician" do
      let(:patient) { FactoryGirl.create(:user) }
      let(:physician) { FactoryGirl.create(:user_with_physician_role) }
      let(:careteam) { FactoryGirl.create(:careteam, :patient => patient) }

      before do
        token_sign_in(physician)
        careteam.add_physician(physician)
      end

      context "when the user attempts to remove himself from careteam with valid parameters" do
        it "should be able to remove the member" do
          post :remove_member, :id => careteam.id

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(json['data']).to eq('Removed from careteam successfully')
        end
      end

      context "when the user attempts to remove himself from careteam with invalid parameters" do
        it "should not be able to remove the member" do
          post :remove_member, :id => -1

          expect_json_content
          expect(json['status']).to eq('error')
          expect(json['errors']).to include('No such record')
        end
      end
    end

    context "when the user is logged in as a patient" do
      let(:patient) { FactoryGirl.create(:user) }
      let(:physician) { FactoryGirl.create(:user_with_physician_role) }
      let(:careteam) { FactoryGirl.create(:careteam, :patient_id => patient.id) }

      before do
        token_sign_in(patient)
        careteam.add_member(physician)
      end

      context "member is passed" do
        context "member is valid" do
          it "should remove the member" do
            post :remove_member, :id => careteam.id, :member_id => physician.id

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(json['data']).to eq('Removed from careteam successfully')
          end
        end

        context "member is invalid" do
          it "should render 'Member is invalid'" do
            post :remove_member, :id => careteam.id, :member_id => -1

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('error')
            expect(json['errors']).to eq('Invalid member')
          end
        end
      end

      context "member is not passed" do
        it "should render 'Invalid member'" do
          post :remove_member, :id => careteam.id

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('error')
          expect(json['errors']).to eq('Invalid member')
        end
      end
    end
  end

  describe '#careteams' do
    context "User is not logged in" do
      it "should return unauthorized" do
        get :index
        expect_unauthorized_access
        expect_json_content
      end
    end

    context "User is logged in as a Physician" do
      context "User attempts to access his CareTeams" do
        let(:physician) { FactoryGirl.create(:user_with_physician_role) }
        let(:physician2) { FactoryGirl.create(:user_with_physician_role) }

        before do
          token_sign_in physician
          FactoryGirl.create_list(:careteam_membership, 10, :member => physician)
          FactoryGirl.create_list(:careteam_membership, 10, :member => physician2)
        end

        it "should return all the Careteams for the Physician" do
          get :index

          expect_success_status
          expect_json_content
          expect(json["status"]).to eq("success")

          expect(json["data"].map{ |careteam| careteam['id'] }).to eq(physician.careteams.map { | careteam | careteam.id })
        end
      end
    end

    context "User is logged in as a Patient" do
      context "User attempts to access his CareTeam" do
        let(:patient) { FactoryGirl.create(:user) }
        let(:physician) { FactoryGirl.create(:user_with_physician_role) }

        before do
          token_sign_in patient
          FactoryGirl.create(:careteam, :patient => patient)
        end

        it "should return his careteam" do
          get :index

          expect_success_status
          expect_json_content
          expect(json["status"]).to eq("success")
          expect(json["data"]["id"]).to eq(patient.careteam.id)
        end
      end
    end
  end

  describe '#activities' do
    context 'when the user is not logged in' do
      context 'when the user attempts to access all the activities' do
        it 'should render an error message stating "Authorized users only"' do
          get :activities, :id => 1

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context 'when the user is logged in' do
      let!(:patient) { FactoryGirl.create(:user) }
      let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
      before do
        token_sign_in(patient)
      end

      context 'when the user attempts to filter the records by actions' do
        let(:careteam) { FactoryGirl.create(:careteam) }
        let(:support) { FactoryGirl.create(:user, :role => :support) }
        let(:params) do
          {
            :id => careteam.id,
            :filter => {
              :chart_items => [],
              :actions => [],
              :audited_by => [],
              :from_date => ""
            }
          }
        end

        before do
          careteam.add_member(support)
          careteam.add_member(physician)
        end

        context 'by create action' do
          before do
            params[:filter][:actions] << "create"
          end

          it 'should return the audits with actions as create' do
            get :activities, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            query = careteam.all_audits.where("action = ?" , "create")
            records = ActiveModel::ArraySerializer.new(query, :each_serializer => AuditSerializer).as_json.map { |x| x.deep_stringify_keys }
            expect(json["data"]).to match_array(records)
          end
        end

        context 'by both create and update actions' do
          before do
            params[:filter][:actions] << "create" << "update"
          end
          it 'should return the audits with actions as create or update' do
            get :activities, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            query = careteam.all_audits.where(:action => ['create', 'update'])
            records = ActiveModel::ArraySerializer.new(query, :each_serializer => AuditSerializer).as_json.map { |x| x.deep_stringify_keys }
            expect(json["data"]).to match_array(records)
          end
        end

        context 'by some invalid action value' do
          before do
            params[:filter][:actions] << "myAction"
          end

          it 'should return an empty array' do
            get :activities, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(json["data"].as_json).to eq([])
          end
        end

        context 'when the page and count params are provided' do
          before do
            params[:filter][:actions] << "create"
            params[:page] = 1
            params[:count] = 1
          end

          it 'should paginate the results properly' do
            get :activities, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            records = careteam.all_audits.where(:action => "create")
            expect(json["data"]).to include(AuditSerializer.new(records.first).as_json.deep_stringify_keys)       
          end
        end
      end

      context "when the user attempts to filter the result by from_date" do
        let(:careteam) { FactoryGirl.create(:careteam) }
        let(:support) { FactoryGirl.create(:user, :role => :support) }
        let(:params) do
          {
            :id => careteam.id,
            :filter => {
              :chart_items => [],
              :actions => [],
              :audited_by => [],
              :from_date => ""
            }
          }
        end

        before do
          Audited.audit_class.as_user(patient) do
            Timecop.travel(Date.parse("09/01/2011")) do
              @careteam = FactoryGirl.create(:careteam)
            end
            Timecop.travel(Date.parse("10/01/2015")) do
              @careteam.add_member(support)
            end
            Timecop.travel(2.weeks.ago) do
              @careteam.add_member(physician)
            end
            Timecop.travel(2.days.ago) do
              @careteam.remove_member(physician)
            end
          end
        end

        context "when date is provided as filter" do
          before do
            params[:filter][:from_date] = "09/01/2011"
            params[:id] = @careteam.id
          end

          it "should return all records created after the provided date" do
            get :activities, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            query = @careteam.all_audits.where("created_at >= ?", Date.parse(params[:filter][:from_date]))
            records = ActiveModel::ArraySerializer.new(query, :each_serializer => AuditSerializer).as_json.map { |x| x.deep_stringify_keys }
            expect(json['data']).to match_array(records)
          end
        end

        context "when the filter provided is as 'last 3 weeks'" do
          before do
            params[:filter][:from_date] = 'last 3 weeks'
            params[:id] = @careteam.id
          end

          it "should return all records created within last 3 weeks" do
            get :activities, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            query = @careteam.all_audits.where("created_at >= ?", 3.weeks.ago)
            records = ActiveModel::ArraySerializer.new(query, :each_serializer => AuditSerializer).as_json.map { |x| x.deep_stringify_keys }
            expect(json['data']).to match_array(records)
          end
        end

        context "when the filter provided is as 'last 2 years'" do
          before do
            params[:filter][:from_date] = 'last 2 years'
            params[:id] = @careteam.id
          end

          it "should return all records created within last 2 years" do
            get :activities, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            query = @careteam.all_audits.where("created_at >= ?", 2.years.ago)
            records = ActiveModel::ArraySerializer.new(query, :each_serializer => AuditSerializer).as_json.map { |x| x.deep_stringify_keys }
            expect(json['data']).to match_array(records)
          end
        end

        context "when the filter provided is invalid" do
          before do
            params[:filter][:from_date] = 'last 2 something'
            params[:id] = @careteam.id
          end

          it "should return an empty array" do
            get :activities, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(json['data']).to eq([])
          end
        end

        context "when the filter provided is nil" do
          before do
            params[:filter][:from_date] = nil
            params[:id] = @careteam.id
          end

          it "should return an empty array" do
            get :activities, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            query = @careteam.all_audits
            records = ActiveModel::ArraySerializer.new(query, :each_serializer => AuditSerializer).as_json.map { |x| x.deep_stringify_keys }
            expect(json['data']).to match_array(records)
          end
        end

      end
    end
  end

  describe "careteam_summary" do
    context "when the user is not logged in" do
      it "should return error 'Authorized users only'" do
        get :summary

        expect_unauthorized_access
        expect_json_content
        expect(json['errors']).to include("Authorized users only.")
      end
    end

    context "when the user is logged in" do
      context "as patient" do
        let!(:patient) { FactoryGirl.create(:user) }
        before do
          token_sign_in(patient)
        end

        it "should return error 'Unauthorized access'" do
          get :summary

          expect_unauthorized_access
          expect_json_content
          expect(json['status']).to eq('error')
          expect(json['errors']).to include('Unauthorized access')
        end
      end

      context "as physician" do
        let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
        let!(:patient1) { FactoryGirl.create(:user) }
        let!(:patient2) { FactoryGirl.create(:user) }
        let!(:appointment1) { FactoryGirl.create(:appointment, :physician => physician, :patient => patient1, :date => Date.current - 10) }
        let!(:appointment2) { FactoryGirl.create(:appointment, :physician => physician, :patient => patient2, :date => Date.current - 2) }
        let!(:careteam1) { FactoryGirl.create(:careteam, :patient => patient1) }
        let!(:careteam2) { FactoryGirl.create(:careteam, :patient => patient2) }

        before do
          token_sign_in(physician)
          careteam1.add_member(physician)
          careteam2.add_member(physician)
        end

        context "when the user attempts to get the summary for his careteam" do
          it "should return careteam summary along with the appointment details" do
            get :summary

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(json['data']).to eq({
              "summary" => [
                {
                  "patient" => UserMinimalSerializer.new(appointment1.patient).as_json.stringify_keys,
                  "last_appointment" => appointment1.date.strftime('%Y-%m-%d'),
                  "therapy_count" => appointment1.patient.medications.count
                },
                {
                  "patient" => UserMinimalSerializer.new(appointment2.patient).as_json.stringify_keys,
                  "last_appointment" => appointment2.date.strftime('%Y-%m-%d'),
                  "therapy_count" => appointment2.patient.medications.count
                }
              ]}
            )
          end
        end

        context "when the user attempts to view the summary and has no scheduled appointments" do
          let!(:patient3) { FactoryGirl.create(:user) }
          let!(:careteam3) { FactoryGirl.create(:careteam, :patient => patient3) }
          before do
            careteam3.add_member(physician)
          end

          it "should return just the careteam details" do
            get :summary

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(json['data']['summary']).to include({
              "patient" => UserMinimalSerializer.new(patient3).as_json.stringify_keys,
              "last_appointment" => nil,
              "therapy_count" => patient3.medications.count
            })
          end
        end
      end
    end
  end

end