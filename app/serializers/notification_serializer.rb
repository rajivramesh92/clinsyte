class NotificationSerializer < BaseSerializer

  attributes :id,
    :sender,
    :recipient,
    :link,
    :message,
    :status


  private

  def link
    if object.category == 'Request'
      '/'
    end
  end

  def sender
    UserMinimalSerializer.new(object.sender)
  end

  def recipient
    UserMinimalSerializer.new(object.recipient)
  end

end