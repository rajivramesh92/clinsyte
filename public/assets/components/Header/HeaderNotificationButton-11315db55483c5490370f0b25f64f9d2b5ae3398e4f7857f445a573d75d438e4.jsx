class HeaderNotificationButton extends Component {
  render() {
    return (
      <li className = 'pull-left'>
        <Link to = '/notifications'>
          <Icon icon = { NOTIFICATION_ICON }
            size = 'large'
          />
          <span className = { 'notifcount-header ' + ( this.props.notificationCount ? '' : 'opacity-0' ) }>
            { this.props.notificationCount }
          </span>
          <span className = { 'hidden-xs notification-head' }>
            Notifications
          </span>
        </Link>
      </li>
    )
  }
}
