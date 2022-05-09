class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :exception, :unless => :is_api_request?

  before_filter :configure_permitted_parameters, if: :devise_controller?

  # rescue_from StandardError, :with => :exception_handler

  # Record not found exception Handler
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  # CanCan access denied exception Handler
  rescue_from CanCan::AccessDenied, :with => :unauthorized_access


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, :keys => permitted_user_attributes)
    devise_parameter_sanitizer.permit(:account_update, :keys => permitted_user_attributes.concat([ :current_password ]))
  end

  def permitted_user_attributes
    [
      :email,
      :password,
      :password_confirmation,
      :first_name,
      :last_name,
      :gender,
      :country_code,
      :phone_number,
      :ethnicity,
      :birthdate,
      :role,
      :license_id,
      :preferred_device,
      :time_zone,
      :expiry
    ]
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, params)
  end

  def is_api_request?
    request.path.to_s.include?('/api/')
  end

  def unauthorized_access
    render_exception('Unauthorized access' , 401)
  end

  def record_not_found
    render_exception('No such record', 404)
  end

  def exception_handler(exception)
    render_exception('Something went wrong')
  end

  def render_exception(message, status_code = 500)
    if is_api_request?
      render :json => { :status => "error", :errors =>  [ message ] }, :status => status_code
    else
      render :file => 'public/500.html', :status => status_code
    end
  end
end
