class Api::V1::UsersController < Api::V1::BaseController

  before_filter :validate_password, :only => :destroy
  before_filter :load_user, :only => [ :show, :qr_code, :busy_slots ]

  def search
    users = User.with(roles)
    results = SearchService.new(users, params[:search].try(:values)).search
    success_serializer_responder(paginate(results), UserMinimalSerializer)
  end

  def update
    if current_user.update_with_password(user_params)
      success_serializer_responder(current_user, CurrentUserSerializer)
    else
      error_serializer_responder(current_user)
    end
  end

  def show
    success_serializer_responder(@user, UserSerializer)
  end

  def destroy
    if current_user.inactive!
      success_serializer_responder("Account deleted successfully")
    else
      error_serializer_responder(current_user)
    end
  end

  def qr_code
    png = QRCodeGenerator.new(@user.uuid).generate
    success_serializer_responder(png.to_data_url)
  end

  def busy_slots
    success_serializer_responder(@user.busy_slots, BusySlotSerializer)
  end

  private

  def user_params
    params.require(:user).permit(*permitted_user_attributes.concat([ :current_password ]))
  end

  def load_user
    @user = User.find(params[:id]) rescue nil
    error_serializer_responder("User not found") unless @user.present?
  end

  def validate_password
    if params[:password].nil?
      error_serializer_responder("Password is required")
    elsif !current_user.valid_password?(params[:password])
      error_serializer_responder("Password is invalid")
    end
  end

  def roles
    params[:roles].blank? ? [ "Physician", "Caregiver", "Counselor", "Support" ] : params[:roles]
  end
end
