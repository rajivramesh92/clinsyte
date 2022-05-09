describe SurveyFilter do

  describe "#filter" do
    let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
    let!(:patient1) { FactoryGirl.create(:user) }
    let!(:patient2) { FactoryGirl.create(:user) }
    let!(:patient3) { FactoryGirl.create(:user) }

    let!(:careteam1) { FactoryGirl.create(:careteam, :patient => patient1) }
    let!(:careteam2) { FactoryGirl.create(:careteam, :patient => patient2) }
    let!(:careteam3) { FactoryGirl.create(:careteam, :patient => patient3) }

    let!(:disease1) { FactoryGirl.create(:disease, :patient => patient1) }
    let!(:disease2) { FactoryGirl.create(:disease, :patient => patient2) }
    let!(:disease3) { FactoryGirl.create(:disease, :patient => patient2) }

    let!(:therapy1) { FactoryGirl.create(:strain) }
    let!(:therapy2) { FactoryGirl.create(:strain) }
    let!(:therapy3) { FactoryGirl.create(:strain) }

    let(:treatment_plan1) { FactoryGirl.create(:treatment_plan, patient => patient1) }
    let(:treatment_plan2) { FactoryGirl.create(:treatment_plan, patient => patient1) }
    let(:treatment_plan3) { FactoryGirl.create(:treatment_plan, patient => patient2) }
    let(:treatment_plan4) { FactoryGirl.create(:treatment_plan, patient => patient3) }

    let(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :treatment_plan => treatment_plan1, :strian => therapy1) }
    let(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :treatment_plan => treatment_plan2, :strain => therapy3) }
    let(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :treatment_plan => treatment_plan3, :strain => therapy2) }
    let(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :treatment_plan => treatment_plan4, :strain => therapy2) }

    let!(:patients) { [ patient1.id, patient2.id, patient3.id ] }

    before do
      careteam1.add_member(physician)
      careteam2.add_member(physician)
      careteam3.add_member(physician)
    end

    context "when the user attempts to filter the patients based on conditions [EXAMPLE 1]" do
      let!(:conditions) { [ disease2.condition.id ] }

      it "should return the filtered patient ids array" do
        response = SurveyFilter.new(patients, { :conditions => conditions }).filter
        patient_conditions = response.map { |id| ( conditions - User.find(id).conditions.map(&:id)).blank? }
        expect(patient_conditions).to be_all {true}
      end
    end

    context "when the user attempts to filter the patients based on conditions [EXAMPLE 2]" do
      let!(:conditions) { [ disease1.condition.id, disease2.condition.id ] }

      it "should return the filtered patient ids array" do
        response = SurveyFilter.new(patients, { :conditions => conditions }).filter
        patient_conditions = response.map { |id| ( conditions - User.find(id).conditions.map(&:id)).blank? }
        expect(patient_conditions).to be_all {true}
      end
    end

    context "when the user attempts to filter the patients based on conditions [EXAMPLE 3]" do
      let!(:conditions) { [ ] }

      it "should return all the patients" do
        response = SurveyFilter.new(patients, { :conditions => conditions }).filter
        expect(response).to match_array(patients)
      end
    end

    context "when the user attempts to filter the patients based on therapies [EXAMPLE 1]" do
      let!(:therapies) { [ therapy1.id ] }

      it "should return the filtered patient ids array" do
        response = SurveyFilter.new(patients, { :therapies => therapies }).filter
        patient_conditions = response.map { |id| ( therapies - User.find(id).strains.map(&:id)).blank? }
        expect(patient_conditions).to be_all {true}
      end
    end

    context "when the user attempts to filter the patients based on therapies [EXAMPLE 2]" do
      let!(:therapies) { [ therapy1.id, therapy2.id ] }

      it "should return the filtered patient ids array" do
        response = SurveyFilter.new(patients, { :therapies => therapies }).filter
        patient_conditions = response.map { |id| ( therapies - User.find(id).strains.map(&:id)).blank? }
        expect(patient_conditions).to be_all {true}
      end
    end

    context "when the user attempts to filter the patients based on therapies [EXAMPLE 3]" do
      let!(:therapies) { [ ] }

      it "should return all the patients" do
        response = SurveyFilter.new(patients, { :therapies => therapies }).filter
        expect(response).to match_array(patients)
      end
    end

    context "when the user attempts to filter the patients by both Conditions and Strains" do
      let!(:filter) do
        {
         :conditions => [ disease1.condition.id ],
         :therapies => [ therapy2.id ]
        }
      end

      it "should return the filtered patient list" do
        response = SurveyFilter.new(patients, filter).filter
        conditions = filter[:conditions]
        therapies = filter[:therapies]
        result = response.map { |id| ( (conditions - User.find(id).conditions.map(&:id)).blank?  &&  (therapies - User.find(id).strains.map(&:id)).blank? ) }
        expect(result).to be_all {true}
      end
    end

    context "when the filters passed are empty arrays" do
      let!(:filter) do
        {
         :conditions => [ ],
         :therapies => [ ]
        }
      end

      it "should return all the patients" do
        response = SurveyFilter.new(patients, filter).filter
        expect(response).to match_array(patients)
      end
    end
  end

end