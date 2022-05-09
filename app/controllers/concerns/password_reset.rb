# Note:
# The following methods can be overrided by the class which
# includes this module to render customized response.
# 1. render_user_not_found_error
# 2. render_medium_not_verified_error
# 3. render_code_sent_success
# 4. render_verification_success
# 5. render_invalid_verification_code
# 6. render_password_reset_success
# 7. render_password_reset_error
#

module Concerns
  module PasswordReset
    extend ActiveSupport::Concern

    included do
      # Skip token authentication for password reset using verification code
      skip_before_filter :authenticate_user!

      # Filters for the password reset request
      before_filter :check_for_medium, :only => :create
      before_filter :load_user_by_medium, :only => :create
      before_filter :find_medium_name_by_user, :only => :create

      # Filters for verifying user by the unique verification code
      before_filter :check_for_verification_code, :only => :validate_verification_code
      before_filter :load_user_by_verification_code, :only => :validate_verification_code
    end

    def create
      send_verification_code
    end

    def validate_verification_code
      if @user.present? && @user.nullify_verification_code
        reset_token = @user.send(:set_reset_password_token)
        render_verification_success_with(reset_token)
      else
        render_invalid_verification_code
      end
    end

    def reset_password
      @user = User.reset_password_by_token(params)
      if @user.valid?
        render_password_reset_success
      else
        render_password_reset_error
      end
    end

    protected

    def load_user_by_medium
      @user = User.where("email = ? OR CONCAT('+', country_code, phone_number) = ?", params[:medium], params[:medium].to_s).first
    end

    def load_user_by_verification_code
      @user = User.find_by_verification_code(params[:verification_token]) rescue nil
    end

    def find_medium_name_by_user
      return unless @user.present?

      @medium = case params[:medium]
      when @user.email
        "email"
      when @user.formatted_phone_number
        "phone_number"
      end
    end

    def send_verification_code
      if @user.nil?
        render_user_not_found_error
      elsif !@user.send("#{@medium}_verified?")
        render_medium_not_verified_error
      else
        @user.send("send_#{@medium}_verification_code")
        render_code_sent_success
      end
    end

    def medium_name
      @medium.to_s.titleize.downcase
    end

    def render_user_not_found_error
      error_serializer_responder("No user found for '#{params[:medium]}'")
    end

    def render_medium_not_verified_error
      error_serializer_responder("Entered #{medium_name} is not verified")
    end

    def render_code_sent_success
      success_serializer_responder("Verification code sent successfully")
    end

    def check_for_verification_code
      error_serializer_responder("Verification code required to reset the password") unless params[:verification_token].present?
    end

    def check_for_medium
      error_serializer_responder("Email or phone number is required to reset the password") unless params[:medium].present?
    end

    def render_verification_success_with(reset_token)
      success_serializer_responder({ :reset_password_token => reset_token })
    end

    def render_invalid_verification_code
      error_serializer_responder("Verification code is invalid")
    end

    def render_password_reset_success
      success_serializer_responder("Password reset successfully")
    end

    def render_password_reset_error
      error_serializer_responder(@user.new_record? ? "Invalid reset password token" : @user)
    end

  end
end