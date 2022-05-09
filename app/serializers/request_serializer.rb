class RequestSerializer < BaseSerializer

  attributes :id,
    :sender,
    :recipient,
    :status

  private

  def sender
    return nil unless object.sender.present?
    UserMinimalSerializer.new(object.sender).as_json
  end

  def recipient
    return nil unless object.recipient.present?
    unless object.recipient.patient?
      UserMinimalSerializer.new(object.recipient).as_json
    else
      UserMinimalSerializer.new(object.recipient).as_json.merge!({:careteam_id => object.recipient.careteam.id})
    end
  end

end