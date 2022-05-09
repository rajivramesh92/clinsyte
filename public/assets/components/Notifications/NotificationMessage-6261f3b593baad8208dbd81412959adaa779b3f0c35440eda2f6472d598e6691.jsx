class NotificationMessage extends Component {

  constructor(props) {
    super(props)
  }

  render() {
    var token = this.props.token;
    var notification = this.props.notification;
    return (
      <div className = 'row'>
        <div className = 'col-sm-9'>
          { notification.message }
        </div>
        <div className = 'col-sm-3'>
          <span className = 'pull-right action notification-close red font-size-14'
            onClick={ () => this.props.onRemove(notification.type, token) }>
            <Icon icon = { REJECT_ICON }/>
          </span>
          <span className='pull-right margin-right-10'>
            <Link to={ notification.link }
              onClick={ () => this.props.onRemove(notification.type, token) }>
              View &nbsp;&crarr;
            </Link>
          </span>
        </div>
      </div>
    );
  }
}
