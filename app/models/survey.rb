class Survey < ActiveRecord::Base

  enum :status => [
    :active,
    :inactive
  ]

  # Default scope
  default_scope do
    active.order(:created_at => :desc)
  end

  # Assosiations
  has_many :tag_connections, {
    :as => :taggable_entity,
    :class_name => EntityTagConnection,
    :dependent => :destroy
  }

  belongs_to :creator, :class_name => 'User'
  has_many :questions, :inverse_of => :survey, :dependent => :destroy
  has_many :answers, :through => :questions
  has_many :user_survey_forms
  has_many :survey_configurations
  has_many :tags, :through => :tag_connections

  # Validations
  validates_presence_of :creator
  validates_presence_of :name

  # Nested attributes
  accepts_nested_attributes_for :questions, :allow_destroy => true

  # Method to check if survey has any responses or not
  # If it has responses, it is not editable then
  def is_editable?
    !answers.present?
  end

  private

  def self.created_by_admin
    admin_users = User.includes(:role).select { |user| user.admin? }.map(&:id)
    Survey.where("creator_id IN (?)", admin_users)
  end

  def self.created_by_study_admin
    study_admin_users = User.select { |user| user.study_admin? }.map &:id
    Survey.where("creator_id IN (?)", study_admin_users)
  end

end
