class TreatmentPlanSerializer < BaseSerializer

  attributes :id,
    :title,
    :creator,
    :orphaned,
    :therapies

  private

  def therapies
    treatment_plan_therapies = object.reload.therapies
    treatment_plan_therapies.map do | therapy |
      TreatmentPlanTherapySerializer.new(therapy).as_json
    end
  end

  def creator
    UserMinimalSerializer.new(object.creator).as_json
  end

  def orphaned
    object.orphaned?
  end

end