class UserCalendar extends Component {
  constructor(){
    super();
    this.state = {
      slots: [],
      busySlots: [],
      unavailableSlots: [],
      showAppoinmentConfirmModal: false,
      modalMessage: '',
      selectedSlots: [],
      isFetching: true
    };
    this.calendarElementId = 'physician-calendar';
    this.getFreeAndBusySlots = this.getFreeAndBusySlots.bind(this);
    this.bookAppointment = this.bookAppointment.bind(this);
    this.onModalClose = this.onModalClose.bind(this);
  }

  getFreeAndBusySlots(){
    var busySlots = _.map(this.state.busySlots, (slot) => {
      return getBusySlotForCalendar(slot.from_time, slot.to_time, slot.date);
    });

    var unavailableSlots = busySlots.concat(_.flatten(_.map(this.state.unavailableSlots, (slot) => {
      return getUnavailableSlotInSlotTiming(slot.from_time, slot.to_time, slot.date);
    })));

    var e =  _.flatten(_.map(this.state.slots, (slot) => {
      return getSlotsInSlotTiming(slot.from_time, slot.to_time, slot.day, unavailableSlots);
    })).
    concat(busySlots);

    return e;
  }

  getSlots(){
    var params = { id: this.props.params.id, include_busy: true }
    var token = this.props.token;
    getSlots(params, token, (response, error) => {
      if(response) {
        if(response.data.status === 'success') {
          this.setState({
            slots: response.data.data.free_slots,
            busySlots: response.data.data.busy_slots,
            unavailableSlots: response.data.data.unavailable_slots,
            isFetching: false
          });
        }
        else {
          showToast(response.data.errors, 'error')
        }
      }
      else {
        showToast('Something went wrong!', 'error');
      }
    });
  }

  bookAppointment(appointmentInfo){
    var fromTime = appointmentInfo.start.format('HH:mm A');
    var toTime = appointmentInfo.end.format('HH:mm A');
    var onDate  = appointmentInfo.start.format('DD/MM/YYYY');
    var modalMessage = 'Do you want to request for a appoinment from ' + fromTime + ' to ' + toTime + ' on ' + onDate;
    var showAppoinmentConfirmModal = true;

    this.setState({
      showAppoinmentConfirmModal,
      modalMessage
    });
    this.appointmentInfo = appointmentInfo;
    this.selectedSlots = (this.selectedSlots || []).concat(appointmentInfo._id);
  }

  onModalClose(message) {
    if(message === 'confirm') {
      var start = this.appointmentInfo.start;
      var end = this.appointmentInfo.end;

      var params = {
        from_time: start.time().asSeconds(),
        to_time: end.time().asSeconds(),
        date: start.format('DD/MM/YYYY'),
        physician_id: this.props.params.id
      };

      var successCallback = (response) => {
        if ( response.data && response.data.status == 'success' ){
          this.setState({
            selectedSlots: this.selectedSlots,
            showAppoinmentConfirmModal: false
          });
          showToast('Appointment request made successfully', 'success');
        }
        else{
          showToast(response.data.errors, 'error');
        }
      }.bind(this);

      var errorCallback = (error) => {
        showToast('Something went wrong', 'error');
      }

      createAppointment(params, this.props.token, successCallback, errorCallback);
    }
  }

  componentDidMount(){
    this.getSlots();
  }

  renderCalendar() {
    var fetching = this.state.isFetching;
    if (_.isNull(fetching) || fetching) {
      return <PreLoader visible = { true } />
    }

    return (
      <Calendar elementId = { this.calendarElementId }
        slots = { this.getFreeAndBusySlots() }
        onEventClick = { this.bookAppointment }
        selectedSlots = { this.state.selectedSlots }
      />
    )
  }

  render(){
    return (
      <div className = 'row'>
        <div className = 'col-md-2 col-xs-12'></div>
        <div className = 'col-md-8 col-xs-12'>
          <h5>
            <Note header = 'Schedule appointment'
              message = 'Click on the slot to schedule the appointment.'
              className = 'pull-right'
            />
          </h5>
          <div className = 'margin-top-40'>
            { this.renderCalendar() }
          </div>
        </div>
        <div className = 'col-md-2 col-xs-12'></div>
        <Confirm show = { this.state.showAppoinmentConfirmModal }
          message = { this.state.modalMessage }
          title = 'Confirm Appointment'
          onClose = { this.onModalClose }
        />
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

UserCalendar = connect(mapStateToProps)(UserCalendar);
