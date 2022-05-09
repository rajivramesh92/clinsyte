class Api::V1::Users::ChartController < Api::V1::BaseController

  include ActivitiesHelper

  before_filter :load_user
  before_filter :validate_user_access
  before_filter :validate_physician, :only => [ :approve ]

  def show
    success_serializer_responder(@user, PatientChartSerializer)
  end

  def update
    @user.update(:chart_approved => false) if current_user.patient?
    update_chart
  end

  def activities
    records = filter_records(@user.all_audits)
    success_serializer_responder(paginate(records), AuditSerializer)
  end

  # Accessible by just the physician
  def approve
    @user.update(:chart_approved => true)
    update_chart
  end

  private

  def validate_user_access
    valid_user = current_user.patient? ? current_user.eql?(@user) : current_user.associated_patients.include?(@user.id)
    error_serializer_responder("Unauthorized access to patient chart") unless valid_user
  end

  def validate_physician
    error_serializer_responder("Chart Approval can be only done by Physicians") unless current_user.physician?
  end

  def load_user
    @user = User.find(params[:id]) rescue nil
    error_serializer_responder('Invalid User') if !@user.present? || !@user.patient?
  end

  def user_params
    chart_params.require(:basic).permit(:height, :weight, :birthdate, :gender, :ethnicity)
  end

  def diseases_params
    diseases = condition_params
    diseases[:diseases_attributes] = diseases.delete(:conditions) || []
    diseases[:diseases_attributes].to_a.each do | disease |
      disease[:symptoms_attributes] = ( disease.delete(:symptoms) || [] ) rescue []
      disease[:medications_attributes] = ( disease.delete(:medications) || [] ) rescue []
    end
    diseases[:treatment_plans_attributes] = diseases.delete(:treatment_plans) || []
    diseases[:treatment_plans_attributes].to_a.each do | plan |
      plan = validate_owner(plan)
      next if plan.blank?
      plan[:therapies_attributes] = ( plan.delete(:therapies) || [] ) rescue []
      plan[:therapies_attributes].to_a.each do | therapy |
        therapy[:dosage_frequencies_attributes] = ( therapy.delete(:dosage_frequency) || [] ) rescue []
        association_parameters = ( therapy.delete(:association_entities) || [] ) rescue []
        therapy[:entity_connections_attributes] = get_connection_data(association_parameters)
      end
    end.delete({})

    diseases
  end

  def condition_params
    chart_params.permit(:conditions => [
      :id,
      :name,
      :diagnosis_date,
      :_destroy,
      :symptoms => [
        :id,
        :name,
        :_destroy
      ],
      :medications => [
        :id,
        :name,
        :description,
        :_destroy
      ],
    ],
    :treatment_plans => [
      :id,
      :title,
      :_destroy,
      :therapies => [
        :id,
        :strain_id,
        :dosage_quantity,
        :dosage_unit,
        :message,
        :intake_timing,
        :_destroy,
        :dosage_frequency => [
          :id,
          :name,
          :value,
          :_destroy
        ],
        :association_entities => [
          :id,
          :entity_type,
          :entity_name,
          :_destroy
        ]
      ]
    ])
  end

  def chart_params
    params.require(:chart)
  end

  def update_chart
    begin
      @user.update!(user_params)
      @user.update!(diseases_params.to_h)
      success_serializer_responder(@user.reload, PatientChartSerializer)
    rescue StandardError => e
      error_serializer_responder(@user)
    end
  end

  def get_connection_data(attributes)
    attributes.map do |attribute|
      entity = @user.send(attribute[:entity_type].pluralize).find_by_name(attribute[:entity_name])
      undefined_entity_connection_error(attribute[:entity_name]) unless entity.present?
      {
        :id => attribute[:id],
        :associated_entity_id => entity.id,
        :associated_entity_type => attribute[:entity_type].capitalize,
        :_destroy => attribute[:_destroy] || false
      }
    end
  end

  def validate_owner(plan)
    treatment_plan = TreatmentPlan.find(plan['id']) rescue nil
    if treatment_plan.nil?
      plan["creator_id"] = current_user.id
    elsif !treatment_plan.creator.eql?(current_user)
      plan.clear
    end

    plan
  end

  def undefined_entity_connection_error(entity_name)
    @user.errors.add(entity_name.to_sym, "doesn't belongs to the Patient")
  end

end
