# Roles
# :patient - Patient (primary owner of account and data)
# :physician - Patient's primary physician/care team member
# :counselor - Health/Medical Counselor (e.g. Genetic Counselor)
# :dispensary - Dispensary / Dispensary rep
# :support - Authorized Scriptyx employees interacting with patient/physician/dispensary
# :admin - Authorized Scriptyx system admin with full access
# :caregiver - Users who take care of patients

class Role < ActiveRecord::Base

  # Associations
  has_many :user_roles, :inverse_of => :role, :dependent => :destroy

  # Validations
  validates :name, :presence => true, :uniqueness => true

  # Constants
  ROLES = all

  def underscored_name
    name.to_s.downcase.gsub(' ', '_')
  end

  def pluralized_name
    underscored_name.pluralize
  end

  # Helpers
  # Provides helpers like,
  # Role.admin => #<Role id: 1, name: admin ...>
  # Role.patient => #<Role id: 2, name: patient ...>
  class << self
    def method_missing(method, *args, &block)
      super if ROLES.empty?

      ROLES.detect do | role |
        role.underscored_name.eql?(method.to_s)
      end
    end
  end

  # Method to convert to object to string
  # Return role name when object is asked to convert into string
  def to_s
    name
  end
end
