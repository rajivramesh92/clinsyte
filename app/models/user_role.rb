class UserRole < ActiveRecord::Base

  # Associations
  belongs_to :user, :inverse_of => :user_role
  belongs_to :role, :inverse_of => :user_roles

  # Validations
  validates :user, :presence => true
  validates :role, :presence => true
  validates_uniqueness_of :user_id, :scope => :role_id

  begin
    Role.all.each do | role |
      # Scopes
      # Provides scope like. admins, patients, dispensaries
      scope role.pluralized_name, -> { where(:role => role) }

      # Helper method
      # Provides helpers like. admin?, patient?, dispensary?
      define_method "#{role.underscored_name}?" do
        self.role.try(:name).eql?(role.name)
      end
    end
  rescue StandardError => e
    Rails.logger.info "Unable to load helpers"
  end
end
