class CurrentUserSerializer < UserSerializer

  attributes :current_physician,
   :phone_number_verified,
   :email_verified

  private

  def current_physician
    return unless object.patient?

    primary_physician = object.careteam.primary_physician
    requests = object.sent_requests.includes(:recipient)
    physician = primary_physician || requests.pending.last.try(:recipient)

    return unless physician.present?
    notifications = Notification.where(:sender => physician, :recipient => object)
    UserMinimalSerializer.new(physician).as_json.merge({
      :status => !!primary_physician,
      :icon => ( notifications.any? ? ( notifications.seen.any? && primary_physician ? nil :
      'accepted' ) : 'pending' )
    })
  end

  def phone_number_verified
    object.phone_number_verified?
  end

  def email_verified
    object.email_verified?
  end

end