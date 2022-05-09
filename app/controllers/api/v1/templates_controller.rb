class Api::V1::TemplatesController < Api::V1::BaseController

  authorize_resource
  before_filter :load_template, :only => [ :toggle_access_level, :destroy, :update ]

  def index
    success_serializer_responder(current_user.templates, TemplateSerializer)
  end

  def create
    template = current_user.templates.new(create_template_params)
    if template.save
      success_serializer_responder('Template saved successfully')
    else
      error_serializer_responder(template)
    end
  end

  def show
    success_serializer_responder(@template, TemplateSerializer)
  end

  def update
    begin
      @template.update!(update_template_params)
      success_serializer_responder("Template updated successfully")
    rescue
      error_serializer_responder(@template)
    end
  end

  def destroy
    if @template.destroy
      success_serializer_responder("Template removed successfully")
    else
      error_serializer_responder("Template removal unsuccessfull")
    end
  end

  def toggle_access_level
    begin
      @template.update!(access_level_params)
      success_serializer_responder("Template access level changed to '#{@template.reload.access_level}'")
    rescue
      error_serializer_responder("Access Level Toggling unsuccessfull")
    end
  end

  def check_availability
    unless params[:name].blank?
      success_serializer_responder(Template.available_with?(params[:name]))
    else
      error_serializer_responder("Name was sent blank")
    end
  end

  private

  def create_template_params
    params.require(:template).permit(
      :id,
      :strain_id,
      :name,
      :template_data_attributes => [
        :id,
        :message
      ]
    )
  end

  def update_template_params
    params.require(:template).permit(
      :template_data_attributes => [
        :id,
        :message
      ]
    )
  end

  def access_level_params
    params.permit(:access_level)
  end

  def load_template
    @template = current_user.templates.find(params[:id]) rescue nil
    error_serializer_responder("No such Template") if @template.nil?
  end

end
