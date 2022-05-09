# Controller which overrides the invitations updation

class Api::V1::Users::InvitationsController < ::Devise::InvitationsController

  before_filter :validate_password_fields, :only => :update

  layout false

  def update
    # Creating user record and skipping validation
    @user = accept_resource
    update_basic_data
    accept_request
    message = { :notice => 'Invitation accepted successfully!' }
    redirect_to "/?#{message.to_param}"
  end

  private

  def validate_password_fields
    @resource = User.new(invite_params)
    @resource.valid?
    if @resource.errors[:password].present?
      render :edit
    end
  end

  def update_basic_data
    @user.generate_uniq_id
    @user.password = invite_params[:password]
    @user.role = Role.patient
    @user.save(:validate => false)
    @user.email_verify!
  end

  def accept_request
    Notification.where(:recipient => @user).map(&:seen!)
    Request.where({
      :sender => @user.invited_by,
      :recipient => @user
    }).last.accept!
  end

  def invite_params
    params.require(:user).permit(:password, :password_confirmation, :invitation_token)
  end

end
