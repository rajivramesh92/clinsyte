class SlotManager extends Component {

  constructor(props) {
    super(props)
    this.state = {
      slots: []
    };
    this.addSlot = this.addSlot.bind(this);
    this.removeSlot = this.removeSlot.bind(this);
    this.showDone = this.props.location.search.toLowerCase() === '?sign_up=true';
  }

  getSlots() {
    if ( this.props.user ){
      var params = { id: this.props.user.id };
      var token = this.props.token;
      getSlots(params, token, (response, error) => {
        if(response) {
          if(response.data.status === 'success') {
            this.setState({
              slots: response.data.data
            });
          }
          else {
            showToast(response.data.errors, 'error')
          }
        }
        else {
          showToast('Something went wrong', 'error');
        }
      });
    }
  }

  addSlot(slot) {
    addSlot(slot, this.props.token, (response, error) => {
      if(response) {
        if(response.data.status === 'success') {
          this.setState({
            slots: this.state.slots.concat(response.data.data)
          })
          showToast('Slot added', 'success')
        }
        else {
          showToast(response.data.errors, 'error')
        }
      }
      else {
        showToast('Unexpected error have occured','error');
      }
    })
  }

  removeSlot(slotId) {
    deleteSlot(slotId, this.props.token, (response, error) => {
      if(response) {
        if(response.data.status === 'success') {
          var slots = _.reject(this.state.slots, { id: slotId })
          this.setState({
            slots
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

  componentDidMount() {
    this.getSlots();
  }

  render() {
    var groupedSlots = _.groupBy(this.state.slots, 'type');
    return (
      <SlotManagerView timeSlots = { groupedSlots['available'] || [] }
        unavailableSlots = { groupedSlots['unavailable'] || [] }
        onAddSlot = { this.addSlot }
        onRemoveSlot = { this.removeSlot }
        signedInFirstTime = { this.props.signedInFirstTime }
        showDone = { this.showDone }>
        <span className = 'font-size-14'>
          Auto Confirm Appointments?
        </span>
        <div className = 'pull-right'>
          <AppointmentPreferences />
        </div>
      </SlotManagerView>
    )
  }
}

var mapStateToProps = (state) => {
  return {
    user: state.auth.user,
    token: state.auth.token
  }
}

SlotManager = connect(mapStateToProps)(SlotManager);
