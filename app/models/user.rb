class User < ActiveRecord::Base

  # Including devise modules.
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable, :invitable

  # For Token Authentication
  include DeviseTokenAuth::Concerns::User

  # For Verification
  include Verifiable

  # Configuring verifiable columns
  # Takes column and callback as arguments. Callback will be executed after setting the
  # verification code on the 'user' object
  #
  # If 'email' is configured as 'verifiable field', then 'send_email_verification_code'
  # email_verified? and email_verify! methods will be defined automatically
  #
  verifiable :email => :send_email, :phone_number => :send_sms

  # Enumerations
  enum :status => [
    :active,
    :inactive
  ]

  enum :privilege => [
    :admin,
    :study_admin
  ]

  enum :preferred_device => [
    :web,
    :android,
    :ios,
    :both_ios_and_android
  ]

  # Associations
  has_one :user_role, {
    :inverse_of => :user,
    :dependent => :destroy
  }
  has_many :diseases, {
    :foreign_key => :patient_id,
    :dependent => :destroy
  }
  has_many :received_requests, {
    :foreign_key => :recipient_id,
    :class_name => 'Request'
  }
  has_many :sent_requests, {
    :foreign_key => :sender_id,
    :class_name =>'Request'
  }
  has_many :careteam_memberships, {
    :foreign_key => :member_id,
    :dependent => :destroy
  }
  has_many :sent_notifications, {
    :as => :sender,
    :class_name => 'Notification',
    :dependent => :destroy
  }
  has_many :received_notifications, {
    :as => :recipient,
    :class_name => 'Notification',
    :dependent => :destroy
  }
  has_many :genetics, {
    :foreign_key => :patient_id,
    :dependent => :destroy
  }
  has_many :scheduled_appointments, {
    :foreign_key => :patient_id,
    :class_name => 'Appointment'
  }
  has_many :received_appointments, {
    :foreign_key => :physician_id,
    :class_name => 'Appointment'
  }
  has_many :received_surveys, {
    :foreign_key => :receiver_id,
    :class_name => 'UserSurveyForm'
  }
  has_many :sent_surveys, {
    :foreign_key => :sender_id,
    :class_name => 'UserSurveyForm'
  }
  has_many :tag_connections, {
    :as => :taggable_entity,
    :class_name => EntityTagConnection,
    :dependent => :destroy
  }
  has_many :created_treatment_plans, {
    :class_name => TreatmentPlan,
    :foreign_key => :creator_id
  }

  has_one :role, :through => :user_role
  has_many :conditions, :through => :diseases
  has_many :symptoms, :through => :diseases
  has_many :medications, :through => :diseases
  has_many :careteams, :through => :careteam_memberships
  has_many :slots, :foreign_key => :physician_id
  has_many :available_slots, :foreign_key => :physician_id
  has_many :unavailable_slots, :foreign_key => :physician_id
  has_one :appointment_preference, :foreign_key => :physician_id
  has_many :surveys, :foreign_key => :creator_id
  has_many :answers, :foreign_key => :creator_id
  has_many :survey_configurations, :foreign_key => :sender_id
  has_many :treatment_plans, :foreign_key => :patient_id
  has_many :event_dependent_surveys, :foreign_key => :physician_id
  has_many :templates, :foreign_key => :creator_id
  has_many :tags, :through => :tag_connections

  # For tracking changes to the record
  begin
    audited :only => [ :height, :weight, :birthdate, :gender, :ethnicity ], :on => [ :update, :destroy ]
    has_associated_audits
  rescue ActiveRecord::StatementInvalid
    puts 'Unable to define associations for audit'
  end

  # Nested Attributes
  accepts_nested_attributes_for :diseases, :allow_destroy => true
  accepts_nested_attributes_for :genetics, :allow_destroy => true
  accepts_nested_attributes_for :treatment_plans, :allow_destroy => true

  # Scopes
  default_scope { active }
  scope :unconfirmed, -> { where("cast(verification_status ->> 'email' as boolean) = false") }

  # Delegate
  delegate :auto_confirm, to: :appointment_preference

  # Callbacks
  before_validation :set_provider_and_uid
  before_validation :generate_uniq_id, :if => :new_record?
  before_create :set_default_role, :if => -> { user_role.nil? }
  after_commit :send_confirmation_email, :on => :create
  after_create :create_appointment_preference, :if => -> { respond_to?(:physician?) && send(:physician?) }
  before_save :validate_privilege, :if => -> { privilege && privilege_changed? }

  # Validations
  validates_presence_of :first_name, :last_name, :gender, :ethnicity, :uuid,
    :phone_number, :country_code, :email
  validate :birthdate_is_valid?
  validates :phone_number, {
    :numericality => true,
    :allow_nil => false,
    :format => { :with => /\A\d{5,15}\Z/ }
  }
  validates :country_code, :length => 1..5

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, {
    :presence => true,
    :length => { :maximum => 255 },
    :format => { :with => EMAIL_REGEX }
  }
  validates_with DuplicationValidator, :fields => ['phone_number', 'email'], :if => (:email_changed? || :phone_number_changed?)

  # Class Methods
  def self.physicians
    joins(:role).where("user_roles.role_id = #{Role.physician.id}")
  end

  def self.activity_name
    "basic info"
  end

  # Method to check if List needs to be returned
  def list_is_renderable
    ["physician?", "admin?", "study_admin?"].any? {|role_check| self.send(role_check)}
  end

  # This method accepts stringified role(s). Ex. ["Physician", "Patient"].
  # and returns the users with the given roles.
  def self.with(roles)
    roles = [ roles.try(:to_s) ].compact unless roles.kind_of?(Array)
    return none if roles.empty?

    prepared_roles = roles.map { | role | role.to_s.capitalize }
    joins(:role).where("roles.name in (?)", prepared_roles)
  end

  def self.admin_and_study_admins
    where(:privilege => [
      User.privileges[:admin],
      User.privileges[:study_admin]
    ])
  end

  # Instance Methods
  def as_json(options = {})
    UserSerializer.new(self)
  end

  def privilege_enum
    enum_keys_for(User.privileges)
  end

  def preferred_device_enum
    enum_keys_for(User.preferred_devices)
  end

  def generate_uniq_id
    write_attribute(:uuid, SecureRandom.uuid.upcase!)
  end

  def careteam
    return unless self.patient?
    Careteam.find_or_create_by(:patient => self)
  end

  # Overridding setter for more security
  def uuid=(value)
    value
  end

  def role=(input)
    super if input.is_a?(ActiveRecord::Base)

    role_instance = Role.send(input.downcase.gsub(' ', '_').try(:to_sym)) rescue nil
    self.role = role_instance if role_instance.present?
  end

  def user_name
    "#{ 'Dr. ' if physician? }#{ first_name || 'User' } #{last_name}".strip
  end

  # Skip validation for invited patients when no detail is given
  def valid?(context = nil)
    return true if invitation_accepted_at.present?
    super(context)
  end

  # Helper methods
  # Gives methods like. patient?, doctor? etc.
  begin
    Role.all.each do | role |
      method_name = "#{role.underscored_name}?".to_sym
      define_method method_name do
        user_role && user_role.send(method_name)
      end
    end
  rescue StandardError => e
    Rails.logger.info "Unable to define user helper methods"
  end

  def active_for_authentication?
    email_verified?
  end

  def send_confirmation_email
    self.set_verification_code
    send_email(:confirmation => true)
  end

  def busy_slots
    apps = physician? ? received_appointments : scheduled_appointments
    apps.valid
  end

  def all_audits
    query = "( auditable_type = 'User' AND auditable_id = #{id} )" +
      " OR ( associated_type = 'User' AND associated_id = #{id} ) "
    Audit.where(query).reorder('created_at DESC')
  end

  def formatted_phone_number
    return "" if ( country_code.blank? || phone_number.blank? )
    "+#{country_code.to_i}#{phone_number.to_i}"
  end

  def rails_admin_default_object_label_method
    user_name
  end

  # Returns recent appointment between a patient and a physician
  def self.recent_appointment_between(physician, patient)
    physician.received_appointments.
      where("patient_id = ? and date < ? ", patient.id, Time.now.utc.to_date).last
  end

  # Returns array of patient ids who belongs to any of the physician's careteam
  def associated_patients
    self.careteams.map { | careteam | careteam.patient.id } rescue []
  end

  # Added enum for providing Drop down in Rail Admin for Roles
  def role_enum
    [
      "Patient",
      "Physician",
      "Counselor",
      "Dispensary",
      "Support",
      "Caregiver"
    ]
  end

  def strains
    treatment_plans.map { |treatment_plan| treatment_plan.therapies.map &:strain }.flatten
  end

  # Method to notify if a ->
  # Patient user has some pending or started TPD survey requests
  # Physician user has some pending or started sent TPD surveys requests
  def has_pending_tpd_surveys?
    get_pending_tpd_survey_requests.present?
  end

  # Method to return ->
  # All the received TPD survey requests for a patient with pending and started status
  # All the sent TPD survey requests for a physician with pending and started status
  def pending_tpd_surveys
    get_pending_tpd_survey_requests
  end

  # Method to return all pending TPD survey requests based on user role accessing this function
  # pending here is referred to as the requests that has not been submitted yet
  def get_pending_tpd_survey_requests
    raise 'Needs to be a Patient or a Physician' unless ( patient? or physician? )
    survey_requests = self.patient? ? received_surveys : sent_surveys
    survey_requests.tpd.pending
  end

  # Method to return user's local time based on the Time Zone specified
  def get_local_time
    ActiveSupport::TimeZone.new(time_zone).now rescue ActiveSupport::TimeZone["UTC"].now
  end

  # Method to return user's local time converted to UTC
  def get_local_time_in_utc
    get_local_time.utc
  end

  private

  def enum_keys_for(options)
    options.map do | option, _ |
      [ option.titleize, option ]
    end
  end

  def set_default_role
    self.build_user_role(:role => Role.patient) unless self.admin?
  end

  def set_provider_and_uid
    self.provider = 'email' if provider.blank?
    self.uid = email if self.uid.blank?
  end

  def birthdate_is_valid?
    errors.add(:birthdate, "can't be blank") if birthdate.blank?
    begin
      Date.parse(birthdate.to_s)
    rescue ArgumentError
      errors.add(:birthdate, "must be a valid date")
    end
  end

  def send_email(options = {})
    EmailWorker.perform_async({
      :emailer_class => "UserMailer",
      :method => :send_verification_token_email,
      :arguments => [ self.id, options ]
    })
  end

  def send_sms
    VerificationCodeSender.perform_async({
      :to => self.formatted_phone_number,
      :verification_code => self.verification_code
    })
  end

  def validate_privilege
    return check_promotion_to_admin_role if admin?
    return check_promotion_to_study_admin_role if study_admin?
  end

  def check_promotion_to_admin_role
    role_promotion_error unless role.blank? or physician?
  end

  def check_promotion_to_study_admin_role
    role_promotion_error unless support?
  end

  def role_promotion_error
    errors.add(:base, "Role can not be promoted")
    return false
  end

end
