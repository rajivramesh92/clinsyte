describe PatientChartSerializer do

  context 'when an object is displayed using PatientChartSerializer' do
    let!(:patient) { FactoryGirl.create(:user) }
    let!(:physician) { FactoryGirl.create(:user_with_physician_role) }

    let!(:disease1) { FactoryGirl.create(:disease, :patient => patient) }
    let!(:disease2) { FactoryGirl.create(:disease, :patient => patient) }
    let!(:genetics) { FactoryGirl.create(:genetic, :patient => patient) }
    let!(:strain) { FactoryGirl.create(:strain) }

    # Pending Treatment Plan Surveys for patients
    let!(:normal_survey) { FactoryGirl.create(:survey, :creator => physician) }
    let!(:tpd_survey) { FactoryGirl.create(:survey, :creator => physician, :treatment_plan_dependent => true) }

    let!(:treatment_plan) { FactoryGirl.create(:treatment_plan, :patient => patient, :creator => physician) }
    let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :treatment_plan => treatment_plan) }

    let!(:normal_survey_request) { FactoryGirl.create(:user_survey_form, :sender => physician, :receiver => patient, :survey => normal_survey) }
    let!(:tpd_survey_request) { FactoryGirl.create(:user_survey_form, :sender => physician, :receiver => patient, :survey => tpd_survey) }

    it 'should render the object with the attributes defined in the PatientChartSerializer' do
      expect(PatientChartSerializer.new(patient).as_json).to eq({
        :basic =>
          {
            :birthdate => patient.birthdate.to_time.strftime("%s%3N"),
            :gender => patient.gender,
            :ethnicity => patient.ethnicity,
            :height => patient.height,
            :weight => patient.weight
          },
        :conditions => [
          {
            :id => disease1.id,
            :name => disease1.condition.name,
            :diagnosis_date => disease1.diagnosis_date.to_time.strftime("%s%3N"),
            :symptoms => [],
            :medications => []
          },
          {
            :id => disease2.id,
            :name => disease2.condition.name,
            :diagnosis_date => disease2.diagnosis_date.to_time.strftime("%s%3N"),
            :symptoms => [],
            :medications => []
          }],
        :genetics => [
          {
            :id => genetics.id,
            :name => genetics.name,
            :variations => []
          }],
        :name => patient.user_name,
        :treatment_plans => [
          {
            :id => treatment_plan.id,
            :title => treatment_plan.title,
            :creator => UserMinimalSerializer.new(physician).as_json,
            :orphaned => true,
            :therapies => [
              {
                :id => treatment_plan_therapy.id,
                :strain =>
                  {
                    :id => treatment_plan_therapy.strain.id,
                    :name => treatment_plan_therapy.strain.name
                  },
                :dosage_quantity => treatment_plan_therapy.dosage_quantity,
                :dosage_unit => treatment_plan_therapy.dosage_unit,
                :message => treatment_plan_therapy.message,
                :intake_timing => treatment_plan_therapy.intake_timing,
                :dosage_frequency => [],
                :association_entities => []
              }
            ]
          }
       ],
       :pending_tpd_surveys => true,
       :approved => true
      })
    end
  end

end