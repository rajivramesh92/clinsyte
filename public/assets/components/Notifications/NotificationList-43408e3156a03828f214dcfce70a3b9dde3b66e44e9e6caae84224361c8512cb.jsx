class NotificationList extends Component {

  constructor(props){
    super(props);
    this.renderNotifications = this.renderNotifications.bind(this);
    this.renderNotificationMessage = this.renderNotificationMessage.bind(this);
  }

  renderNotificationMessage(notification) {
    return (
      <div className = 'list-group-item'
       key = { notification.type }>
        <NotificationMessage notification={ notification }
          onRemove = { this.props.onRemove }
          token = { this.props.token }
        />
      </div>
    )
  }

  renderNotifications() {
    if(_.isEmpty(this.props.notifications)){
      return (
        <NoItemsFound message = 'No new notifications!'
          icon = { NOTIFICATION_ICON }
        />
      );
    }
    else{
      return (
        <div className = 'list-group'>
          { renderItems(this.props.notifications, this.renderNotificationMessage) }
        </div>
      )
    }
  }

  render() {
    return (
      <div>
        <div className='row'>
          <div className='col-sm-8 col-sm-offset-2'>
            <h5 className='text-center'>Notifications</h5>
          </div>
        </div>
        <div className = 'row'>
          <div className='col-sm-8 col-sm-offset-2'>
            { this.renderNotifications() }
          </div>
        </div>
      </div>
    )
  }
}
