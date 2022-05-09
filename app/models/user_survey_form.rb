class UserSurveyForm < ActiveRecord::Base

  # Assosiations
  belongs_to :sender, :class_name => "User"
  belongs_to :receiver, :class_name => "User"
  belongs_to :survey
  has_many :answers, :foreign_key => :request_id
  has_many :descriptive_answers, :foreign_key => :request_id
  has_many :multiple_choice_answers, :foreign_key => :request_id
  has_many :range_based_answers, :foreign_key => :request_id
  has_many :list_driven_answers, :foreign_key => :request_id
  has_many :treatment_plan_version_records

  # Default_Scope
  default_scope { joins(:survey).where("surveys.status = ?", Survey.statuses[:active]).order(:created_at => :desc) }
  scope :pending, -> { where("state IN (?)", %w{pending started})  }
  scope :tpd, -> { joins(:survey).where('surveys.treatment_plan_dependent = ?', true) }

  #Validations
  validates_presence_of :survey
  validates_presence_of :sender
  validates_presence_of :receiver

  # Callbacks
  after_initialize :set_initial_status
  after_create :create_notification
  after_create :save_treatment_plan_versions

  # Delegate
  delegate :questions, :to => :survey
  delegate :treatment_plan_dependent, :to => :survey

  # State Machine
  state_machine :state, :initial => :pending do
    event :start do
      transition :pending => :started
    end

    event :submit do
      transition :started => :submitted
    end

    before_transition :pending => :started do | survey_form |
      survey_form.validate_treatment_plan_versions if survey_form.treatment_plan_dependent
    end

    after_transition :pending => :started do | survey_form |
      survey_form.touch :started_at
    end

    after_transition :started => :submitted do | survey_form |
      survey_form.touch :submitted_at
    end

  end

  def create_notification(category = :survey_request_initiated)
    Notification.create(notification_attributes_for(category))
  end

  def notification_attributes_for(category)
    source, destination = category.eql?(:survey_request_initiated) ? [ sender, receiver ] : [ receiver, sender ]
    {
      :sender => source,
      :recipient => destination,
      :message => I18n.t("notifications.#{category}", :count => 1, :sender => source.user_name),
      :category => category.to_s
    }
  end

  # Method to check if Treatment Plan Version has been changed against the received request
  def validate_treatment_plan_versions
    receiver.treatment_plans.each do | treatment_plan |
      is_a_match = treatment_plan_version_records.find_by(:treatment_plan_id => treatment_plan.id).treatment_plan_version.eql?(treatment_plan.current_version)
      raise 'Treatment Plan version has been changed' unless is_a_match
    end
  end

  private

  def set_initial_status
    self.state ||= :pending
    self.sent_at ||= Time.zone.now
  end

  def save_treatment_plan_versions
    receiver.treatment_plans.each do | treatment_plan |
      treatment_plan_version_records.create(:treatment_plan => treatment_plan, :treatment_plan_version => treatment_plan.current_version)
    end
  end

end
