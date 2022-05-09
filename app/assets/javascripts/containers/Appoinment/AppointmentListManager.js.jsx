class AppointmentListManager extends Component {

  constructor(props) {
    super(props)
    this.state = {
      requests: []
    }
    this.onAccept = this.onAccept.bind(this);
    this.onReject = this.onReject.bind(this);
  }

  componentWillMount() {
    getAppointmentRequests(this.props.token, (response,error) => {
      if(response) {
        if(response.data.status.toLowerCase() === 'success') {
          this.setState({
            requests: response.data.data
          })
        }
        else {
          showToast(response.data.errors, 'error');
        }
      }
      else {
        showToast('Something went wrong', 'error');
      }
    })
  }

  changeStatus(requestId, status) {
    changeAppointmentStatus(requestId, status, this.props.token, (response, error) => {
      if(response) {
        if(response.data.status.toLowerCase() === 'success') {
          var requests = _.reject(this.state.requests, { id: requestId })
          this.setState({
            requests
          })
          showToast(response.data.data, 'success')
        }
        else {
          showToast(response.data.errors, 'error');
        }
      }
      else {
        showToast('Something went wrong', 'error');
      }
    })
  }

  onAccept(requestId) {
    this.changeStatus(requestId, 'accept');
  }

  onReject(requestId) {
    this.changeStatus(requestId, 'decline');
  }

  render() {
    return (
      <AppointmentList requests = { this.state.requests }
        onAccept = { this.onAccept }
        onReject = { this.onReject }
      />
    )
  }
}

var mapStateToProps = (state) => {
  return {
    token: state.auth.token
  }
}

AppointmentListManager = connect(mapStateToProps)(AppointmentListManager);
