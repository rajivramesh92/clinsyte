class MyCalendar extends Component{
  constructor(){
    super();
    this.state = {
      appointments: [],
      showAppoinmentCancelModal: false,
      modalMessage: '',
      cancelledAppointments: [],
      newRequests: [],
      isFetching: null
    };

    this.calendarElementId = 'my-calendar';
    this.getAppointmentsData = this.getAppointmentsData.bind(this);
    this.cancelAppointment = this.cancelAppointment.bind(this);
    this.onModalClose = this.onModalClose.bind(this);
  }

  getAppointmentsData(){
    return _.map(this.state.appointments, (a) => {
      var message = 'Appointment with ';
      message += a[isPatient(this.props.user) ? "physician" : "patient"].name;

      return Object.assign(getBusySlotForCalendar(a.from_time, a.to_time, a.date, message), { id: a.id, className: 'appointment-slot' });
    });
  }

  getAppointments(){
    var successCallback = (response) => {
      if ( response.data && response.data.status == 'success' ){
        this.setState({
          appointments: response.data.data,
          isFetching: false
        });
      }
      else {
        showToast(response.data.errors, 'error');
      }
    }

    var errorCallback = (error) => {
      showToast(SOMETHINGWRONG, 'error');
    }
    var token  = this.props.token;
    this.setState({ isFetching: true });
    getAppointments(token, successCallback, errorCallback);
  }

  getNewRequests() {
    getAppointmentRequests(this.props.token, (response, error) => {
      if(response && response.data.status === 'success') {
        this.setState({
          newRequests: response.data.data
        })
      }
      else {
        show(SOMETHINGWRONG, 'error')
      }
    })
  }

  componentDidMount(){
    this.getAppointments();
    this.getNewRequests();
  }

  cancelAppointment(appointmentInfo){
    var fromTime = appointmentInfo.start.format('HH:mm A');
    var toTime = appointmentInfo.end.format('HH:mm A');
    var onDate  = appointmentInfo.start.format('DD/MM/YYYY');
    var modalMessage = 'Do you want to cancel the ' + appointmentInfo.title + ' from ' + fromTime + ' to ' + toTime + ' on ' + onDate + '?';
    var showAppoinmentCancelModal = true;

    this.setState({
      showAppoinmentCancelModal,
      modalMessage
    });
    this.appointmentInfo = appointmentInfo;
  }

  renderCalendar() {
    var fetching = this.state.isFetching;
    if (_.isNull(fetching) || fetching) {
      return <PreLoader visible = { true } />
    }

    var defaultDate = this.props.location.query.date;
    return (
      <Calendar elementId = { this.calendarElementId }
        slots = { this.getAppointmentsData() }
        defaultDate = { defaultDate ? new Date(defaultDate) : null }
        onEventClick = { this.cancelAppointment }
        hiddenSlots = { this.state.cancelledAppointments }
      />
    )
  }

  onModalClose(message) {
    if(message === 'confirm') {
      var successCallback = (response) => {
        if ( response.data.status && response.data.status == 'success' ){
          this.setState({
            cancelledAppointments: this.state.cancelledAppointments.concat(this.appointmentInfo.id),
            showAppoinmentCancelModal: false
          });
          showToast(response.data.data, "success");
        }
        else{
          showToast(response.data.errors, "error");
        }
      }.bind(this);

      var errorCallback = (error) => {
        showToast("Something went wrong", "error");
      }

      var token = this.props.token;
      cancelAppointment(this.appointmentInfo.id, token, successCallback, errorCallback);
    }
  }

  renderNewRequestNotification() {
    var count = this.state.newRequests.length;
    if(count > 0) {
      return (
        <span className = 'notifcount-header invite-count'>
          { count }
        </span>
      )
    }
  }

  renderNewRequestsButton() {
    if (isPhysician(this.props.user)) {
      return (
      <Link to = '/appointment/requests'
        className = 'no-link pull-right margin-right-10'
        title = 'Appointment Requests'>
        <Icon icon = { APPOINTMENT_REQUEST_ICON }/>
        { this.renderNewRequestNotification() }
      </Link>
      )
    }
  }

  render(){
    return (
      <div className = 'row'>
        <div className = 'col-md-8 col-md-offset-2'>
            <h5 className = 'text-center'>
              My Calendar
              <Note header = 'Cancel appointment'
                message = 'Click on the slot to cancel the appointment'
                className = 'pull-right'
              />
              { this.renderNewRequestsButton() }
            </h5>
            { this.renderCalendar() }
            <Confirm show = { this.state.showAppoinmentCancelModal }
              message = { this.state.modalMessage }
              title = 'Cancel Appointment'
              onClose = { this.onModalClose }
            />
        </div>
      </div>
    );
  }
}

var mapStateToProps = (state) => {
  return {
    user: state.auth.user,
    token: state.auth.token
  }
}

MyCalendar = connect(mapStateToProps)(MyCalendar);
