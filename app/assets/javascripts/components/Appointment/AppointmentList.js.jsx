class AppointmentList extends Component {

  constructor(props) {
    super(props);
    this.renderRequest = this.renderRequest.bind(this);
  }

  renderRequest(request, index) {
    var getDateTimeFor = (request) => {
      return moment(request.date, 'YYYY-MM-DD').format('LL') + ' ' + getHours(request.from_time);
    }

    return (
      <div key = { request.id }
        className = 'list-group-item'>
        <div className = 'vertically-centered'>
          { index + 1}.&nbsp;&nbsp;
        </div>
        <div className = 'vertically-centered full-width'>
          <div className = 'row'>

            <div className = 'col-sm-8 text-mobile-center'>
              <ChartLink user = { request.patient }/>&nbsp;
              is requested for an appointment on&nbsp;
              <span className = 'font-bold'>
                { getDateTimeFor(request) }
              </span>
            </div>

            <div className = 'col-sm-2 col-xs-6 text-center'>
              <button className='btn btn-link invite-actions blue'
                onClick={ () => this.props.onAccept(request.id) }>
                <Icon icon = { ACCEPT_ICON }/>&nbsp;Accept
              </button>
            </div>

            <div className = 'col-sm-2 col-xs-6 text-center'>
              <button className='btn btn btn-link remove-btn red'
                onClick={ () => this.props.onReject(request.id) }>
                <Icon icon = { REJECT_ICON }/>&nbsp;Reject
              </button>
            </div>

          </div>
        </div>
      </div>
    )
  }

  renderRequests() {
    if(!this.props.requests.length) {
      return (
        <NoItemsFound message = 'No new Requests!'
          icon = { APPOINTMENT_REQUEST_ICON }
        />
      )
    }
    return (
      <div className = 'list-group'>
        { renderItems(this.props.requests, this.renderRequest) }
      </div>
    )
  }

  render() {
    return (
      <div className = 'container'>
        <div className = 'row'>
          <div className = 'col-md-8 col-md-offset-2'>
            <h5 className = 'text-center'>Appointment Requests</h5>
          </div>
        </div>
        <div className = 'row'>
          <div className = 'col-md-8 col-xs-12 col-md-offset-2'>
            { this.renderRequests() }
          </div>
        </div>
      </div>
    )
  }
}

AppointmentList.propTypes = {
  requests: PropTypes.array.isRequired,
  onAccept: PropTypes.func,
  onReject: PropTypes.func
}
