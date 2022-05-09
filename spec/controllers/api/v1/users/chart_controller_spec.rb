describe Api::V1::Users::ChartController do

  describe '#update' do
    context 'when the user is not logged in' do
      context 'when the user tries to update the patient chart' do
        it 'should render an error message stating "Authorized users only"' do
          post :update, :id => 1

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context 'when the user is logged in' do
      let!(:patient) { FactoryGirl.create(:user) }
      let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
      let!(:careteam) { FactoryGirl.create(:careteam, :patient => patient) }

      before do
        token_sign_in(physician)

        # Add physician to patient's careteam
        careteam.add_member(physician)

        @disease1 = FactoryGirl.create(:disease, :patient => patient)

        @symptom1 = @disease1.symptoms.create(:name => 'sympton1')
        @symptom2 = @disease1.symptoms.create(:name => 'symptom2')

        @medication1 = @disease1.medications.create(:name => 'medication1')
        @medication2 = @disease1.medications.create(:name => 'medication2')

        @genetic = FactoryGirl.create(:genetic, :patient => patient)
        @variation1 = FactoryGirl.create(:variation, :genetic => @genetic)
        @phenotype1 = FactoryGirl.create(:phenotype, :variation => @variation1)

      end

      let(:params) do
        {
          :id => patient.id,
          :chart => {
            :basic => {
              :height => patient.height,
              :weight => patient.weight,
              :birthdate => patient.birthdate,
              :gender => patient.gender
            },
            :conditions => [
              {
                :id => @disease1.id,
                :name => @disease1.name,
                :diagnosis_date => @disease1.diagnosis_date,
                :_destroy => false,
                :symptoms => [
                  {
                    :id => @symptom1.id,
                    :name => @symptom1.name,
                    :_destroy => false
                  },
                  {
                    :id => @symptom2.id,
                    :name => @symptom2.name,
                    :_destroy => false
                  }
                ],
                :medications => [
                  {
                    :id => @medication1.id,
                    :name => @medication1.name,
                    :description => @medication1.description,
                    :_destroy => false
                  },
                  {
                    :id => @medication2.id,
                    :name => @medication2.name,
                    :description => @medication2.description,
                    :_destroy => false
                  }
                ]
              }
            ],
            :treatment_plans => []
          }
        }
      end

      context 'when the user attempts to change the pateint details - height|weight|gender etc' do
        before do
          params[:chart][:basic][:height] = '100'
          params[:chart][:basic][:weight] = 200
          params[:chart][:basic][:gender] = "Female"
        end
        it 'should update the details for the Patient' do
          post :update, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          patient.reload
          expect(patient.height).to eq('100')
          expect(patient.weight).to eq(200)
          expect(patient.gender).to eq('Female')
        end
      end

      context 'when the user attempts to add some disease for the patient' do
        before do
          disease2 = {
            :name => 'disease2',
            :diagnosis_date => Date.current,
            :symtoms => [],
            :medication => []
          }
          params[:chart][:conditions] << disease2
        end

        it 'should add the disease to the Patient-Chart' do
          post :update, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(patient.diseases).to be_any do | disease |
            disease.condition[:name] == 'disease2' &&
            disease.diagnosis_date == Date.current
          end
          expect(patient.diseases.last.symptoms).to eq([])
          expect(patient.diseases.last.medications).to eq([])
        end
      end

      context 'when the user attempts to add some symptoms and medications for a disease' do
        before do
          symptom3 = {
            :name => 'symptom3'
          }
          medication3 = {
            :name => 'medication3',
            :description => 'description3'
          }
          params[:chart][:conditions][0][:symptoms] << symptom3
          params[:chart][:conditions][0][:medications] << medication3
        end
        it 'should update the Patient-Chart with the new symptoms and medications' do
          post :update, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(patient.diseases.first.symptoms).to be_any{ | symptom | symptom.name == 'symptom3'}
          expect(patient.diseases.first.medications).to be_any do | medication |
            medication.name == 'medication3' && medication.description == 'description3'
          end
        end
      end

      context 'when the user attempts to remove a disease' do
        before do
          params[:chart][:conditions][0]['_destroy'] = true
        end
        it 'should remove the disease from the Patient-Chart' do
          post :update, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(patient.diseases).to be_none do | disease |
            disease.condition.name == @disease1.condition['name']
          end
        end
      end

      context 'when the user attempts to remove symptom|medication for a disease' do
        before do
          params[:chart][:conditions][0][:symptoms][1][:_destroy] = true
          params[:chart][:conditions][0][:medications][0][:_destroy] = true
        end

        it 'should remove the symptom|medication for that disease' do
          post :update, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(patient.diseases.first.medications).to be_none do | medication |
            medication.name == @medication1.name
          end
          expect(patient.diseases.first.symptoms).to be_none do | symptom |
            symptom.name == @symptom2.name
          end
        end
      end

      context 'when the user attempts to update the patient chart with some invalid paramters' do
        before do
          params[:chart][:basic][:birthdate] = 'xyz'
        end
        it 'should render an error message stating "Invalid Fields provided"' do
          post :update, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('error')
          expect(json['errors']).to include("Birthdate must be a valid date")
        end
      end

      context 'when the id passed as the parameters is not a valid id' do
        before do
          params[:id] = -1
        end
        it 'should render an error message stating "Invalid User"' do
          post :update, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('error')
          expect(json['errors']).to include("Invalid User")
        end
      end

      context 'when the user is not a patient' do
        before do
          params[:id] = physician.id
        end
        it 'should render an error message  stating "Invalid User"' do
          post :update, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('error')
          expect(json['errors']).to include("Invalid User")
        end
      end

      ## TREATMENT PLAN

      context "when the user attempts to create Treatment Plan for the patient" do
        let!(:strain) { FactoryGirl.create(:strain) }
        let!(:condition) { FactoryGirl.create(:condition) }
        let!(:symptom1) { FactoryGirl.create(:symptom) }
        let!(:symptom2) { FactoryGirl.create(:symptom) }

        before do
          params[:chart][:treatment_plans] <<
          {
            :title => "Treatment Plan 1",
            :therapies => [
              {
                :strain_id => strain.id,
                :dosage_quantity => 2.2,
                :dosage_unit => 'gm',
                :message => 'Take medicines 3 times a day',
                :intake_timing => "am",
                :_destroy => false,
                :dosage_frequency => [
                  {
                    :name => 'no more than n times a day',
                    :value => 3
                  }
                ],
                :association_entities => [
                  {
                    :entity_type => 'condition',
                    :entity_name => patient.conditions.last.name
                  },
                  {
                    :entity_type => 'symptom',
                    :entity_name => patient.symptoms.last.name
                  }
                ]
              }
            ]
          }
        end

        it 'should create the Treatment Plan for the user' do
          post :update, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')

          treatment_plan = patient.treatment_plans.last
          entity_connection1 = treatment_plan.therapies.last.entity_connections.first
          entity_connection2 = treatment_plan.therapies.last.entity_connections.last
          entity1 = Object.const_get(entity_connection1.associated_entity_type).find(entity_connection1.associated_entity_id)
          entity2 = Object.const_get(entity_connection2.associated_entity_type).find(entity_connection2.associated_entity_id)

          expect(json['data']).to include(
            "treatment_plans"=> [
              {
                "id" => patient.treatment_plans.last.id,
                "title" => patient.treatment_plans.last.title,
                "creator" => UserMinimalSerializer.new(physician).as_json.stringify_keys,
                "orphaned" => patient.treatment_plans.last.orphaned?,
                "title" => patient.treatment_plans.last.title,
                "therapies" => [
                  {
                    "id" => patient.treatment_plans.last.therapies.last.id,
                    "strain" => {
                      "id" => strain.id,
                      "name" => strain.name
                    },
                   "dosage_quantity" => params[:chart][:treatment_plans][0][:therapies][0][:dosage_quantity],
                   "dosage_unit" => params[:chart][:treatment_plans][0][:therapies][0][:dosage_unit],
                   "message" => params[:chart][:treatment_plans][0][:therapies][0][:message],
                   "intake_timing" => params[:chart][:treatment_plans][0][:therapies][0][:intake_timing],
                   "dosage_frequency" => [
                      {
                        "id" => patient.treatment_plans.last.therapies.last.dosage_frequencies.last.id,
                        "name" => params[:chart][:treatment_plans][0][:therapies][0][:dosage_frequency][0][:name],
                        "value" => params[:chart][:treatment_plans][0][:therapies][0][:dosage_frequency][0][:value].to_s
                      }
                    ],
                    "association_entities" => [
                      {
                        "id" => entity_connection1.id,
                        "entity_type" => entity_connection1.associated_entity_type.downcase,
                        "entity_object" => {
                          "id" => entity1.id,
                          "name" => entity1.name
                        }
                      },
                      {
                        "id" => entity_connection2.id,
                        "entity_type" => entity_connection2.associated_entity_type.downcase,
                        "entity_object" => {
                          "id" => entity2.id,
                          "name" => entity2.name
                        }
                      }
                    ]
                  }
                ]
              }
            ]
          )
        end
      end

      context "when the user attempts to add duplicate entity for the Treatment Plan" do
        let!(:symptom) { patient.symptoms.last }
        let!(:treatment_plan) { FactoryGirl.create(:treatment_plan, :patient => patient, :creator => physician) }
        let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :treatment_plan => treatment_plan, :entity_connections_attributes => [ {:associated_entity => symptom} ]) }

        before do
          params[:chart][:treatment_plans] <<
          {
            :id => treatment_plan.id,
            :title => treatment_plan.title,
            :therapies => [
              {
                :id => treatment_plan_therapy.id,
                :strain_id => treatment_plan_therapy.strain.id,
                :dosage_quantity => treatment_plan_therapy.dosage_quantity,
                :dosage_unit => treatment_plan_therapy.dosage_unit,
                :message => treatment_plan_therapy.message,
                :intake_timing => treatment_plan_therapy.intake_timing,
                :_destroy => false,
                :dosage_frequency => [],
                :association_entities => [
                  {
                    :entity_type => 'symptom',
                    :entity_name => patient.symptoms.last.name
                  }
                ]
              }
            ]
          }
        end

        it 'should raise the error "Treatment plans entity connections associated entity has already been taken"' do
          post :update, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('error')
          expect(json['errors']).to include('Treatment plans therapies entity connections associated entity has already been taken')
        end
      end

      context "when the user attempts to remove an entity from the treatment plan" do
        let!(:treatment_plan) { FactoryGirl.create(:treatment_plan, :patient => patient, :creator => physician) }
        let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy,
          :treatment_plan => treatment_plan,
          :entity_connections_attributes => [{ :associated_entity => patient.conditions.last},
          :associated_entity => patient.symptoms.last ]) }
        let!(:deleted_entity) { treatment_plan_therapy.entity_connections.first.id }

        before do
          params[:chart][:treatment_plans] <<
          {
            :id => treatment_plan.id,
            :therapies => [
              {
                :id => treatment_plan_therapy.id,
                :strain_id => treatment_plan_therapy.strain.id,
                :dosage_quantity => treatment_plan_therapy.dosage_quantity,
                :dosage_unit => treatment_plan_therapy.dosage_unit,
                :message => treatment_plan_therapy.message,
                :intake_timing => treatment_plan_therapy.intake_timing,
                :_destroy => false,
                :dosage_frequency => [],
                :association_entities => [
                  {
                    :id => treatment_plan_therapy.entity_connections.first.id,
                    :entity_type => treatment_plan_therapy.entity_connections.first.associated_entity_type.downcase,
                    :entity_name => Condition.find(treatment_plan_therapy.entity_connections.first.associated_entity_id).name,
                    :_destroy => true
                  },
                  {
                    :id => treatment_plan_therapy.entity_connections.last.id,
                    :entity_type => treatment_plan_therapy.entity_connections.last.associated_entity_type.downcase,
                    :entity_name => Symptom.find(treatment_plan_therapy.entity_connections.last.associated_entity_id).name
                  },
                ]
              }
            ]
          }
        end

        it "should remove the targetted entity from the treatment plan" do
          post :update, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')

          expect(patient.treatment_plans.last.therapies.last.entity_connections.map &:id).not_to include(deleted_entity)
        end
      end

      context "when the user attempts to remove the Treatment Plan" do
       let!(:treatment_plan) { FactoryGirl.create(:treatment_plan, :patient => patient, :creator => physician) }
        let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy,
          :treatment_plan => treatment_plan,
          :entity_connections_attributes => [{ :associated_entity => patient.conditions.last},
          :associated_entity => patient.symptoms.last ]) }

        before do
          params[:chart][:treatment_plans] <<
          {
            :id => treatment_plan.id,
            :_destroy => true
          }
        end

        it "should remove the Treatment Plan and all its therapies" do
          post :update, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')

          expect(json["data"]["treatment_plans"]).to be_empty
        end
      end

      context 'when the user attempts to remove a therapy from the Treatment Plan' do
        let!(:treatment_plan) { FactoryGirl.create(:treatment_plan, :patient => patient, :creator => physician) }
        let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :treatment_plan => treatment_plan) }
        let!(:dosage_frequency) { treatment_plan_therapy.dosage_frequencies.create(:name => 'every n hours', :value => '2') }

        before do
          params[:chart][:treatment_plans] <<
          {
            :id => treatment_plan.id,
            :title => treatment_plan.title,
            :therapies => [
              {
                :id => treatment_plan_therapy.id,
                :strain_id => treatment_plan_therapy.strain.id,
                :dosage_quantity => treatment_plan_therapy.dosage_quantity,
                :dosage_unit => treatment_plan_therapy.dosage_unit,
                :message => 'Take medicines 3 times a day',
                :intake_timing => treatment_plan_therapy.intake_timing,
                :_destroy => true,
                :dosage_frequency => [
                  {
                    :id => dosage_frequency.id,
                    :name => dosage_frequency.name,
                    :value => dosage_frequency.value
                  }
                ]
              }
            ]
          }
        end

        it 'should remove the therapy from the Treatment Plan' do
          post :update, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(json['data']).to include({
            "treatment_plans" => [
              {
                "id" => treatment_plan.id,
                "title" => treatment_plan.title,
                "creator" => UserMinimalSerializer.new(physician).as_json.stringify_keys,
                "orphaned" => treatment_plan.orphaned?,
                "therapies" => []
              }
            ]
          })
        end
      end

      context 'when the user attempts to update some Treatment Plan details' do
        let!(:treatment_plan) { FactoryGirl.create(:treatment_plan, :patient => patient, :creator => physician) }
        let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :treatment_plan => treatment_plan) }
        let!(:dosage_frequency) { treatment_plan_therapy.dosage_frequencies.create(:name => 'every n hours', :value => '2') }

        before do
          params[:chart][:treatment_plans] <<
          {
            :id => treatment_plan.id,
            :title => treatment_plan.title,
            :therapies => [
              {
                :id => treatment_plan_therapy.id,
                :strain_id => treatment_plan_therapy.strain.id,
                :dosage_quantity => 10.0,
                :dosage_unit => treatment_plan_therapy.dosage_unit,
                :message => 'Reduce it to 2 times a day',
                :intake_timing => treatment_plan_therapy.intake_timing,
                :_destroy => false,
                :dosage_frequency => [
                  {
                    :id => dosage_frequency.id,
                    :name => dosage_frequency.name,
                    :value => '3'
                  }
                ]
              }
            ]
          }
        end

        it "should update the Treatment Plan accordingly" do
          post :update, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(json['data']).to include(
            "treatment_plans"=> [
              {
                "id" => treatment_plan.id,
                "creator" => UserMinimalSerializer.new(physician).as_json.stringify_keys,
                "title" => treatment_plan.title,
                "orphaned" => treatment_plan.orphaned?,
                "therapies" => [
                  {
                    "id" => treatment_plan_therapy.id,
                    "strain" => {
                      "id" => treatment_plan_therapy.strain.id,
                      "name" => treatment_plan_therapy.strain.name
                    },
                   "dosage_quantity" => params[:chart][:treatment_plans][0][:therapies][0][:dosage_quantity],
                   "dosage_unit" => params[:chart][:treatment_plans][0][:therapies][0][:dosage_unit],
                   "message" => params[:chart][:treatment_plans][0][:therapies][0][:message],
                   "intake_timing" => params[:chart][:treatment_plans][0][:therapies][0][:intake_timing],
                   "dosage_frequency" => [
                      {
                        "id" => params[:chart][:treatment_plans][0][:therapies][0][:dosage_frequency][0][:id],
                        "name" => params[:chart][:treatment_plans][0][:therapies][0][:dosage_frequency][0][:name],
                        "value" => params[:chart][:treatment_plans][0][:therapies][0][:dosage_frequency][0][:value]
                      }
                    ],
                    "association_entities" => []
                  }
                ]
              }
            ]
          )
        end
      end

  # TREATMENT PLAN UPDATION STORY

      context "when the user attempts to edit the treatment plan" do
        let!(:random_physician) { FactoryGirl.create(:user_with_physician_role) }
        let!(:owners_treatment_plan) {  FactoryGirl.create(:treatment_plan, :creator => physician, :patient => patient) }
        let!(:random_treatment_plan1) { FactoryGirl.create(:treatment_plan, :creator => patient, :patient => patient) }
        let!(:random_treatment_plan2) { FactoryGirl.create(:treatment_plan, :creator => random_physician, :patient => patient) }

        let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :treatment_plan => owners_treatment_plan) }
        let!(:dosage_frequency) { treatment_plan_therapy.dosage_frequencies.create(:name => 'every n hours', :value => '2') }
        before do
          params[:chart][:treatment_plans] <<
          {
            :id => owners_treatment_plan.id,
            :title => 'Customized Therapy',
            :therapies => [
              {
                :id => treatment_plan_therapy.id,
                :strain_id => treatment_plan_therapy.strain.id,
                :dosage_quantity => 10.0,
                :dosage_unit => treatment_plan_therapy.dosage_unit,
                :message => 'Reduce it to 2 times a day',
                :intake_timing => treatment_plan_therapy.intake_timing,
                :_destroy => false,
                :dosage_frequency => [
                  {
                    :id => dosage_frequency.id,
                    :name => dosage_frequency.name,
                    :value => '3'
                  }
                ]
              }
            ]
          }
          params[:chart][:treatment_plans] <<
          {
            :id => random_treatment_plan1.id,
            :title => 'Random Treatment Plan 1',
            :therapies => [ ]
          }
          params[:chart][:treatment_plans] <<
          {
            :id => random_treatment_plan2.id,
            :title => 'Random Treatment Plan 2',
            :therapies => [ ]
          }
        end

        it "should only update the treatment plan created by him" do
          random_treatment_plan1_old_title = random_treatment_plan1.title
          random_treatment_plan2_old_title = random_treatment_plan2.title

          post :update, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')

          expect(owners_treatment_plan.reload.title).to eq('Customized Therapy')
          expect(random_treatment_plan1.reload.title).to eq(random_treatment_plan1_old_title)
          expect(random_treatment_plan2.reload.title).to eq(random_treatment_plan2_old_title)
        end
      end

      context "when the user attempts to edit the treatment plan not created by him" do
        let!(:treatment_plan) {  FactoryGirl.create(:treatment_plan, :creator => patient, :patient => patient) }
        before do
          params[:chart][:treatment_plans] <<
          {
            :id => treatment_plan.id,
            :title => 'Customized Therapy',
            :therapies => [ ]
          }
        end
        it "should not update the treatment plan" do
          post :update, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(treatment_plan.reload.title).to eq(treatment_plan.title)
        end
      end


      # Treatment Plan Survey Association

      context "when the patient has pending tpd surveys" do
        let!(:tpd_survey) { FactoryGirl.create(:survey, :treatment_plan_dependent => true, :creator => physician) }
        let!(:tpd_survey_request) { FactoryGirl.create(:user_survey_form, :sender => physician, :receiver => patient, :survey => tpd_survey) }

        let!(:strain) { FactoryGirl.create(:strain) }
        let!(:condition) { FactoryGirl.create(:condition) }

        before do
          params[:chart][:treatment_plans] <<
          {
            :title => "Treatment Plan 1",
            :therapies => [
              {
                :strain_id => strain.id,
                :dosage_quantity => 2.2,
                :dosage_unit => 'gm',
                :message => 'Take medicines 3 times a day',
                :intake_timing => "am",
                :_destroy => false,
                :dosage_frequency => [
                  {
                    :name => 'no more than n times a day',
                    :value => '3'
                  }
                ],
                :association_entities => [
                  {
                    :entity_type => 'condition',
                    :entity_name => patient.conditions.last.name
                  }
                ]
              }
            ]
          }
        end

        it "should return an error message stating 'Treatment Plans can not be updated'" do
          post :update, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('error')
          expect(json['errors']).to include("Treatment plans can not be updated as the patient has pending surveys")
        end
      end

      context "when the user attempts to update an existing treatment plan when patient has existing treatment plans" do
        let!(:treatment_plan) {  FactoryGirl.create(:treatment_plan, :creator => physician, :patient => patient) }
        let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :treatment_plan => treatment_plan) }

        let!(:tpd_survey) { FactoryGirl.create(:survey, :treatment_plan_dependent => true, :creator => physician) }
        let!(:tpd_survey_request) { FactoryGirl.create(:user_survey_form, :sender => physician, :receiver => patient, :survey => tpd_survey) }

        before do
          params[:chart][:treatment_plans] <<
          {
            :id => treatment_plan.id,
            :title => treatment_plan.title,
            :therapies => [
              {
                :id => treatment_plan_therapy.id,
                :strain_id => treatment_plan_therapy.strain.id,
                :dosage_quantity => treatment_plan_therapy.dosage_quantity,
                :dosage_unit => 'mg',
                :message => 'Updating a new message',
                :intake_timing => treatment_plan_therapy.intake_timing,
                :_destroy => false,
                :dosage_frequency => [],
                :association_entities => []
              }
            ]
          }
        end

        it "should return an error message stating 'Treatment Plans can not be updated'" do
          post :update, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('error')
          expect(json['errors']).to include("Treatment plans can not be updated as the patient has pending surveys")
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
        let(:params) do
          {
            :id => patient.id,
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
            @disease1 = FactoryGirl.create(:disease, :patient => patient)
            @disease2 = FactoryGirl.create(:disease, :patient => patient)
            @disease1.update(:name => 'myDisease')
            @disease1.destroy
          end
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
            expect(json["data"].as_json).to be_all { | audit | audit["action"].eql?("create") }
            expect(json["data"].count).to eq(patient.all_audits.where(:action => "create").count)
          end
        end

        context 'by destroy action' do
          before do
            params[:filter][:actions] << "destroy"
          end
          it 'should return the audits with actions as destroy' do
            get :activities, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(json["data"].as_json).to be_all { | audit | audit["action"].eql?("destroy") }
            expect(json["data"].count).to eq(patient.all_audits.where(:action => ["destroy"]).count)
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
            expect(json["data"].as_json).to be_all { | audit | audit["action"].eql?("create") || audit["action"].eql?("update") }
            expect(json["data"].count).to eq(patient.all_audits.where(:action => ["create", "update"]).count)
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
            records = patient.all_audits.where(:action => "create")
            expect(json["data"]).to include(AuditSerializer.new(records.first).as_json.deep_stringify_keys)
          end
        end
      end

      context "when the user attempts to filter the result by from_date" do
        let(:params) do
          {
            :id => patient.id,
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
              @disease1 = FactoryGirl.create(:disease, :patient => patient)
            end
            Timecop.travel(Date.parse("10/01/2015")) do
              @disease2 = FactoryGirl.create(:disease, :patient => patient)
            end
            Timecop.travel(2.weeks.ago) do
              @disease1.update(:name => 'myDisease')
            end
            Timecop.travel(2.days.ago) do
              @disease1.destroy
            end
          end
        end

        context "when date is provided as filter" do
          before do
            params[:filter][:from_date] = '09/01/2011'
          end

          it "should return all records created after the provided date" do
            get :activities, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            query = patient.all_audits.where("created_at >= ?", Date.parse(params[:filter][:from_date]))
            records = ActiveModel::ArraySerializer.new(query, :each_serializer => AuditSerializer).as_json.map { |x| x.deep_stringify_keys }
            expect(json['data']).to match_array(records)
          end
        end

        context "when the filter provided is as 'last 3 weeks'" do
          before do
            params[:filter][:from_date] = 'last 3 weeks'
          end

          it "should return all records created within last 3 weeks" do
            get :activities, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            query = patient.all_audits.where("created_at >= ?", 3.weeks.ago)
            records = ActiveModel::ArraySerializer.new(query, :each_serializer => AuditSerializer).as_json.map { |x| x.deep_stringify_keys }
            expect(json['data']).to match_array(records)
          end
        end

        context "when the filter provided is as 'last 2 years'" do
          before do
            params[:filter][:from_date] = 'last 2 years'
          end

          it "should return all records created within last 2 years" do
            get :activities, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            query = patient.all_audits.where("created_at >= ?", 2.years.ago)
            records = ActiveModel::ArraySerializer.new(query, :each_serializer => AuditSerializer).as_json.map { |x| x.deep_stringify_keys }
            expect(json['data']).to match_array(records)
          end
        end

        context "when the filter provided is invalid" do
          before do
            params[:filter][:from_date] = 'last 2 something'
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
          end

          it "should return an empty array" do
            get :activities, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            query = patient.all_audits
            records = ActiveModel::ArraySerializer.new(query, :each_serializer => AuditSerializer).as_json.map { |x| x.deep_stringify_keys }
            expect(json['data']).to match_array(records)
          end
        end

      end

      context "when the user attempts to filter the results by Chart Items" do
        let(:params) do
          {
            :id => patient.id,
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
            @disease1 = FactoryGirl.create(:disease, :patient => patient)
            @disease2 = FactoryGirl.create(:disease)
            @symptom1 = FactoryGirl.create(:disease_symptom_connection, :disease => @disease1)
            @symptom2 = FactoryGirl.create(:disease_symptom_connection, :disease => @disease2)
            @disease1.update(:name => 'myDisease')
            @medication1 = FactoryGirl.create(:disease_medication_connection, :disease => @disease1)
          end
        end

        context "by Symptom" do
          before do
            params[:filter][:chart_items] << 'Symptom'
          end

          it "should filter the results by Symptoms" do
            get :activities, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            query = patient.all_audits.where("( auditable_type like '%DiseaseSymptomConnection%')")
            records = ActiveModel::ArraySerializer.new(query, :each_serializer => AuditSerializer).as_json.map { |x| x.deep_stringify_keys }
            expect(json['data']).to match_array(records)
          end
        end

        context "by both Symptom and Medication" do
          before do
            params[:filter][:chart_items] << 'Symptom' << 'Medication'
          end

          it "should filter the results by both Symptoms and Medications" do
            get :activities, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            query = patient.all_audits.where("( auditable_type like '%DiseaseSymptomConnection%' ) OR ( auditable_type like '%DiseaseMedicationConnection%' )")
            records = ActiveModel::ArraySerializer.new(query, :each_serializer => AuditSerializer).as_json.map { |x| x.deep_stringify_keys }
            expect(json['data']).to match_array(records)
          end
        end

        context "when the chart_items field is left blank" do
          it "should return all the records" do
            get :activities, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            query = patient.all_audits
            records = ActiveModel::ArraySerializer.new(query, :each_serializer => AuditSerializer).as_json.map { |x| x.deep_stringify_keys }
            expect(json['data']).to match_array(records)
          end
        end
      end

      context "when the user attempts to filter the record by user_ids" do
        let(:params) do
          {
            :id => patient.id,
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
            @patient2 = FactoryGirl.create(:user)
            @disease1 = FactoryGirl.create(:disease, :patient => patient)
            @disease2 = FactoryGirl.create(:disease, :patient => @patient2)
            @symptom1 = FactoryGirl.create(:disease_symptom_connection, :disease => @disease1)
            @symptom2 = FactoryGirl.create(:disease_symptom_connection, :disease => @disease2)
            @disease1.update(:name => 'myDisease')
            @medication1 = FactoryGirl.create(:disease_medication_connection, :disease => @disease1)
          end
        end

        context "user_ids are present" do
          before do
            params[:filter][:audited_by] << patient.id
          end
          it "should return the filtered records" do
            get :activities, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            query = patient.all_audits.where("user_type = 'User' AND user_id IN (?)", params[:filter][:audited_by])
            records = ActiveModel::ArraySerializer.new(query, :each_serializer => AuditSerializer).as_json.map { |x| x.deep_stringify_keys }
            expect(json['data']).to match_array(records)
          end
        end

        context "when the user_ids are blank" do
          it "should return all the records" do
            get :activities, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            query = patient.all_audits
            records = ActiveModel::ArraySerializer.new(query, :each_serializer => AuditSerializer).as_json.map { |x| x.deep_stringify_keys }
            expect(json['data']).to match_array(records)
          end
        end
      end

      context "when multiple filters are applied at the same time" do
        let(:params) do
          {
            :id => patient.id,
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
            Timecop.travel(2.weeks.ago) do
              @disease1 = FactoryGirl.create(:disease, :patient => patient)
            end
            Timecop.travel(1.days.ago) do
              @disease2 = FactoryGirl.create(:disease, :patient => patient)
            end
            @disease1.update(:name => 'mydisease')
            @symptom1 = FactoryGirl.create(:disease_symptom_connection, :disease => @disease1)
          end
        end

        context "date and action filter are applied simultaneously" do
          before do
            params[:filter][:from_date] = "last 2 days"
            params[:filter][:actions] << "create"
          end

          it "should return the filtered results" do
            get :activities, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            query = patient.all_audits.where("DATE(created_at) >= ? AND action = ?", 2.days.ago, 'create')
            records = ActiveModel::ArraySerializer.new(query, :each_serializer => AuditSerializer).as_json.map { |x| x.deep_stringify_keys }
            expect(json['data']).to match_array(records)
          end
        end

        context "date, action and chart_items filters are applied simultaneously" do
          before do
            params[:filter][:from_date] = "last 2 days"
            params[:filter][:actions] << "create"
            params[:filter][:chart_items] << "Symptom" << "Medication"
          end

          it "should return the filtered results" do
            get :activities, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            query = patient.all_audits.where("DATE(created_at) >= ? AND action = ? AND ( auditable_type like '%DiseaseSymptomConnection%' ) OR ( auditable_type like '%DiseaseMedicationConnection%' )", 2.days.ago, 'create')
            records = ActiveModel::ArraySerializer.new(query, :each_serializer => AuditSerializer).as_json.map { |x| x.deep_stringify_keys }
            expect(json['data']).to match_array(records)
          end
        end
      end
    end

  end
end