require 'audit'

class CareteamMembership < ActiveRecord::Base

  # Associations
  belongs_to :careteam
  belongs_to :member, :class_name => 'User'

  # Validations
  validates_presence_of :careteam
  validates_presence_of :member
  validates_uniqueness_of :member_id, :scope => :careteam_id # Composite key validation
  validate :is_valid_level?

  # Access Level Enum
  enum :level => [
    :basic,
    :primary
  ]

  # Callbacks
  after_destroy :set_primary_physician, :if => :primary?

  # For tracking changes to the record
  audited :only => [ :careteam_id, :member_id, :level ], :associated_with => :careteam

  PRIMARY_ACCESS_LEVEL_ERROR = "Must be a physician for primary level"

  # Class Methods
  def self.primary_physician
    primary_membership.try(:member)
  end

  def self.primary_membership
    primary.first
  end

  def self.make_primary!(physician)
    begin
      primary_membership.try(:basic!)
      find_by(:member => physician).try(:primary!)
    rescue ActiveRecord::RecordInvalid => e
      PRIMARY_ACCESS_LEVEL_ERROR
    end
  end

  def self.membership_level_of(member)
    find_by(:member => member).level
  end

  def self.activity_name
    'Careteam'
  end

  # Instance Methods
  def get_activity_value_for(audit)
    if audit.update?
      return unless audit.audited_changes['level'].present?
      audit.audited_changes['level'][-1] = CareteamMembership.levels.key(audit.audited_changes['level'][-1])
      audit.audited_changes
    else
      { :member => UserMinimalSerializer.new(member).as_json, :level => level }
    end
  end

  def get_activity_association(activity)
    member.try(:user_name) if activity.update?
  end

  private

  def is_valid_level?
    if self.primary? && !self.member.try(:physician?)
      errors.add(:level, PRIMARY_ACCESS_LEVEL_ERROR)
    end
  end

  def set_primary_physician
    physicians = careteam.members.physicians
    careteam.make_primary!(physicians.first) if physicians.any?
  end

end
