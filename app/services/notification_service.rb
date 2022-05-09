# A Service to list notifications in the needed format
# `include_read` param is set, all the notifications will be returned.
# By default, this option is set to false, only unread notifications will be returned
#

class NotificationService
  def initialize(user, include_read = false)
    @user = user
    @include_read = include_read
    @notifications ||= ( @include_read ? @user.received_notifications : @user.received_notifications.unseen ) rescue raise_invalid_input
  end

  def notifications
    @notifications.group_by(&:category).map do | key, value |
      {
        :type => key,
        :message => I18n.t("notifications.#{key}", {
          :count => value.count,
          :sender => value.first.sender.try(:user_name) || 'Clinsyte User'
        }),
        :link => I18n.t("notifications.#{key}.link")
      }
    end
  end

  private

  def raise_invalid_input
    raise "Inputs are Invalid"
  end

end