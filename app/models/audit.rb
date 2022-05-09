Audit = Audited.audit_class

class Audit

  # Modules
  include ::Concerns::TimeFilter
  include ::Concerns::Mapper

  # Callbacks
  before_create :set_created_time

  def activity_name
    auditable_type.try(:constantize).try(:activity_name) || auditable_type.to_s.downcase
  end

  def activity_value
    auditable_instance.try(:get_activity_value_for, self) || audited_changes
  end

  def activity_association
    auditable_instance.try(:get_activity_association, self)
  end

  ACTIONS = [ 'create', 'update', 'destroy' ]

  # Defines the create?, update?, destroy? helpers on the instance of Audit class.
  ACTIONS.each do | activity |
    define_method("#{activity}?") do
      self.action.eql?(activity)
    end
  end

  def auditable_instance
    self.auditable ||= ( auditable_type.to_s.constantize.new(audited_changes) rescue nil )
  end


  def self.filter_by_action(actions = [])
    actions = actions.compact.map { | action | action.to_s.downcase }
    return all if actions.empty?
    self.where(:action => actions)
  end

  def self.filter_by_auditable(auditables = [])
    auditables = auditables.compact.map { | auditable | auditable.to_s.camelize }
    return all if auditables.empty?
    conditions = ([ "auditable_type like (?)" ] * auditables.count).join(' OR ')
    self.where(conditions, *(auditables.map { |r| auditable_class_for(r) }))
  end

  def self.filter_by_user_ids(user_ids = [])
    user_ids.compact!
    return all if user_ids.empty?
    self.where("user_type = 'User' AND user_id IN (?)", user_ids).includes(:user)
  end

  private

  def set_created_time
    if self.auditable && !destroy?
      self.created_at = create? ? self.auditable.created_at : Time.zone.now
    end
  end

end