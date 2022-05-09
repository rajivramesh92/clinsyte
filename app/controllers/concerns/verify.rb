module Concerns
  module Verify
    extend ActiveSupport::Concern

    included do
      skip_before_filter :authenticate_user!, :except => :initiate_verification
      before_filter :check_for_token_and_field, :except => :initiate_verification
      before_filter :load_user, :except => :initiate_verification
    end

    def initiate_verification
      field = params[:field].eql?('email') ? 'email' : 'phone_number'
      current_user.send_phone_number_verification_code
      success_serializer_responder('Verification code sent successfully')
    end

    private

    def verify(field)
      @field = field.to_s
      if @user.send("#{@field}_verified?")
        render_already_verified_error
      elsif @user.verify(@field.to_sym, params[:verification_token].to_i)
        render_verify_success
      else
        render_error_message
      end
    end

    def check_for_token_and_field
      if params[:verification_token].nil?
        verification_redirect_with(:error => "Verification token is required") and return
      end

      if params[params[:action].to_sym].nil?
        verification_redirect_with(:error => "#{params[:action].titleize.capitalize} is required") and return
      end
    end

    def load_user
      @user = User.find_by_verification_code(params[:verification_token]) rescue nil
      render_invalid_credentials if invalid_credentials?
    end

    def invalid_credentials?
      @user.nil? || ( params[:email] != @user.email && params[:phone_number] != @user.phone_number.to_s )
    end

    def render_already_verified_error
      verification_redirect_with(:error => "#{@field.titleize.capitalize} is already verified")
    end

    def render_verify_success
      verification_redirect_with(:notice => "#{@field.titleize.capitalize} is verified successfully")
    end

    def render_error_message
      verification_redirect_with(:error => @user.errors.customized_full_messages.first)
    end

    def render_invalid_credentials
      verification_redirect_with(:error => "Invalid Credentials")
    end

    def verification_redirect_with(options = {})
      unless params[:redirect]
        method = options[:notice].present? ? :success_serializer_responder : :error_serializer_responder
        send(method, (options[:notice] || options[:error]))
      else
        redirect_to "#{ENV['VERIFICATION_REDIRECT_URL']}?#{options.to_param}"
      end
    end
  end
end