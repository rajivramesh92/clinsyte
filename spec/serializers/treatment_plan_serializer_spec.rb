describe TreatmentPlanSerializer do

  context "when an object is displayed using TreatmentPlanSerializer" do
    let!(:treatment_plan) { FactoryGirl.create(:treatment_plan) }
    let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :treatment_plan => treatment_plan,
     :dosage_frequencies_attributes => [{:name => "n times a day", :value => 4 }, {:name => "every n hours", :value => 2}],
     :entity_connections_attributes => [{:associated_entity => FactoryGirl.create(:condition)}] )}

    it "should display the object with the attributes defined in TreatmentPlanSerializer" do
      expect(TreatmentPlanSerializer.new(treatment_plan).as_json).to include({
        :id => treatment_plan.id,
        :title => treatment_plan.title,
        :orphaned => treatment_plan.orphaned?,
        :creator => UserMinimalSerializer.new(treatment_plan.creator).as_json,
        :therapies => [
          {
            :id => treatment_plan_therapy.id,
            :strain => {
              :id => treatment_plan_therapy.strain.id,
              :name => treatment_plan_therapy.strain.name
              },
            :dosage_quantity => treatment_plan_therapy.dosage_quantity,
            :dosage_unit => treatment_plan_therapy.dosage_unit,
            :message => treatment_plan_therapy.message,
            :intake_timing => treatment_plan_therapy.intake_timing,
            :dosage_frequency => [
              {
                :id => treatment_plan_therapy.dosage_frequencies.last.id,
                :name => treatment_plan_therapy.dosage_frequencies.last.name,
                :value => treatment_plan_therapy.dosage_frequencies.last.value
              },
              {
                :id => treatment_plan_therapy.dosage_frequencies.first.id,
                :name => treatment_plan_therapy.dosage_frequencies.first.name,
                :value => treatment_plan_therapy.dosage_frequencies.first.value
              }
            ],
            :association_entities => [
              {
                :id => TherapyEntityConnection.last.id,
                :entity_type => TherapyEntityConnection.last.associated_entity_type.downcase,
                :entity_object => {
                  :id => Condition.first.id,
                  :name => Condition.first.name
                }
              }
            ]
          }
        ]
      })
    end
  end
end
