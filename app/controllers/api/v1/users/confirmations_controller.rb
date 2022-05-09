class Api::V1::Users::ConfirmationsController < Api::V1::BaseController
  include Concerns::Verify

  skip_before_filter :load_user, :only => :resend
  skip_before_filter :check_for_token_and_field, :only => :resend
  before_action :load_user_from_email, :only => :resend

  def email
    verify(params[:action])
  end

  def phone_number
    verify(params[:action])
  end

  def resend
    if @user.email_verified?
      error_serializer_responder("Your account is already verified.")
    else
      @user.send_confirmation_email
      success_serializer_responder(I18n.t('devise.confirmations.send_instructions'))
    end
  end

  private

  def load_user_from_email
    unless params[:email].present?
      error_serializer_responder("Email is required")
    else
      @user = User.find_by_email(params[:email])
      error_serializer_responder("The account does not exist") if @user.nil?
    end
  end
end

