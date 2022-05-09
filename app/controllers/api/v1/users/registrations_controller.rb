class Api::V1::Users::RegistrationsController < DeviseTokenAuth::RegistrationsController

  protected

  def sign_up_params
    params.require(:user).permit(*permitted_user_attributes) rescue {}
  end

  def render_create_error
    render :json => {
      :status => 'error',
      :data => @resource.as_json,
      :errors => errors_for_current_resource
    }, :status => 403
  end

  def render_update_error
    render :json => {
      :status => 'error',
      :errors => errors_for_current_resource
    }, :status => 403
  end

  def errors_for_current_resource
    @resource.errors.customized.
      merge(:full_messages => @resource.errors.customized_full_messages)
  end

end