class Api::V1::Users::SessionsController < DeviseTokenAuth::SessionsController
  include ApplicationHelper

  def destroy
    super do
      sign_out_all_scopes
    end
  end

  private

  def update_auth_header
    @used_auth_by_token = false
    super
    if current_user && current_user.active_for_authentication?
      warden.session_serializer.store(current_user, :user)
    end
  end

  def render_create_success
    render :json => {
      :data => get_state
    }
  end

end