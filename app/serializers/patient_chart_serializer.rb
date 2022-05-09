class PatientChartSerializer < BaseSerializer

  attributes :basic,
    :conditions,
    :genetics,
    :name,
    :treatment_plans,
    :pending_tpd_surveys,
    :approved

  private

  def basic
    {
      :birthdate => birthdate,
      :gender => object.gender,
      :ethnicity => object.ethnicity,
      :height => object.height,
      :weight => object.weight
    }
  end

  def conditions
    serialize_collection(object.diseases, DiseaseSerializer)
  end

  def genetics
    serialize_collection(object.genetics, GeneticSerializer)
  end

  def birthdate
    object.birthdate.to_time.strftime("%s%3N") rescue nil
  end

  def name
    object.user_name
  end

  def treatment_plans
    serialize_collection(object.treatment_plans, TreatmentPlanSerializer)
  end

  def approved
    if object.chart_approved.nil?
      true
    else
      object.chart_approved
    end
  end

  def pending_tpd_surveys
    object.reload.has_pending_tpd_surveys?
  end

end

