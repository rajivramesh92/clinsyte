class Api::V1::NotificationsController < Api::V1::BaseController

  before_action :set_notification, :only => [:read, :unread]
  before_action :check_category, :only => :ignore
  authorize_resource :only => [:read, :unread]

  def index
    unread_notifications = paginate(NotificationService.new(current_user).notifications)
    success_serializer_responder(unread_notifications, NotificationSerializer)
  end

  # Endpoint to mark the notification as read
  def read
    @notification.seen!
    success_serializer_responder('Notification marked as read')
  end

  # Endpoint to mark the notification as unread
  def unread
    @notification.unseen!
    success_serializer_responder('Notification marked as unread')
  end

  def ignore
    current_user.received_notifications.send(params[:key]).
      each(&:seen!) rescue nil
    success_serializer_responder('Notifications ignored successfully')
  end

  private

  # Method to set the notification based on the id
  def set_notification
    begin
      @notification = Notification.find(params[:id])
    rescue
      error_serializer_responder("No such Notification")
    end
  end

  def check_category
    if params[:key].nil?
      error_serializer_responder('Key is required')
    elsif Notification.categories.exclude?( params[:key] )
      error_serializer_responder('Invalid key')
    end
  end

end
