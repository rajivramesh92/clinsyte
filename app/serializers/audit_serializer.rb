require 'audit'

class AuditSerializer < BaseSerializer
  attributes :action,
    :owner,
    :message,
    :timestamp

  private

  def owner
    UserMinimalSerializer.new(object.user).as_json if object.user.present?
  end

  def message
    {
      :name => object.activity_name,
      :value => object.activity_value,
      :association => object.activity_association
    }
  end

  def timestamp
    object.created_at.to_time.strftime("%s%3N") rescue nil
  end

end