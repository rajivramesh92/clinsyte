RailsAdmin.config do |config|

  # Devise Authentication
  config.authenticate_with do
    warden.authenticate! scope: :user
  end

  config.current_user_method(&:current_user)

  # Cancan Authorization
  config.authorize_with do
    unless current_user.admin?
      redirect_to "#{main_app.root_path}?error=#{I18n.t('unauthorized_error')}"
    end
  end

  config.model 'Strain' do
    label 'Therapy'

    show do
      exclude_fields :compound_strains
    end

    edit do
      exclude_fields :compound_strains, :compounds, :tags
    end
  end

  config.model 'Compound' do
    edit do
      exclude_fields :compound_strains, :strains
    end
  end

  config.model 'Condition' do
    include_name_and_tag_fields = proc do
      field :name
      field :tags
    end

    list &include_name_and_tag_fields
    edit &include_name_and_tag_fields
  end

  config.model 'CompoundStrain' do
    label 'Compound - Therapy association'

    show do
      exclude_fields :tag_connections
    end

    edit do
      exclude_fields :tag_connections
    end
  end

  config.model 'UserSurveyForm' do
    visible false
  end

  config.model 'User' do
    modify_fields = proc do
      include_all_fields

      field :privilege, :enum do
        formatted_value do
          bindings[:object].privilege
        end
      end

      field :preferred_device, :enum do
        formatted_value do
          bindings[:object].preferred_device
        end
      end

      exclude_fields(
        :reset_password_token,
        :reset_password_sent_at,
        :remember_created_at,
        :current_sign_in_at,
        :last_sign_in_at,
        :current_sign_in_ip,
        :last_sign_in_ip,
        :updated_at,
        :invitation_token,
        :invitation_created_at,
        :invitation_sent_at,
        :invitation_accepted_at,
        :invitation_limit,
        :invited_by_id,
        :invited_by_type,
        :invitations_count,
        :provider,
        :tokens,
        :verification_code,
        :sign_in_count,
        :uid,
        :chart_approved,
        :received_surveys,
        :sent_surveys,
        :conditions,
        :strains,
        :surveys,
        :answers
      )
    end

    list &modify_fields

    show &modify_fields

    edit do
      modify_fields.call
      exclude_fields :uuid, :verification_status
    end
  end

  config.actions do
    dashboard
    index
    new
    export
    bulk_delete
    show
    edit
    delete
  end

  # Whitelisting Models for accessibiltiy
  config.included_models = ["Strain",
    "CompoundStrain",
    "Category",
    "Compound",
    "Condition",
    "Tag",
    "TagGroup",
    "User",
    "UserSurveyForm"
  ]
end