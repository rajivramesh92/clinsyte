const InvitationsNotifyIcon = ({ count, className }) => {

  var renderCount = () => {
    if (count > 0) {
      return (
        <span className = 'notifcount-header invite-count'>
          { count }
        </span>
      );
    }
  }

  return (
    <Link to = '/careteams/invites'
      className = { className }
      title = 'Careteam Invites'>
        <Icon icon = { CARETEAM_INVITE_ICON }/>
        { renderCount() }
    </Link>
  );
}

InvitationsNotifyIcon.propTypes = {
  count: PropTypes.number.isRequired,
  className: PropTypes.string.isRequired
}
