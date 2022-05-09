class MedicineAlertManager extends Component {

  componentWillReceiveProps(nextProps) {
    this.setUpPrivatePub(nextProps);
  }

  componentDidMount() {
    this.setUpPrivatePub(this.props)
  }

  setUpPrivatePub(props) {
    var user = props.user;
    var onReceiveAlert = props.onReceiveAlert;
    var rtParams = props.rtParams;

    if(user && !_.isEmpty(rtParams)) {
      PrivatePub.sign(rtParams);
      var id = user.id;
      PrivatePub.subscribe("/messages/" + id, data => {
        var alert = data.alert
        onReceiveAlert(alert.message, alert.plan_id, alert.therapy_id)
      });
    }
  }

  render() {
    return <MedicineAlert {...this.props} />
  }
}

var mapStateToProps = (state) => {
  var alert = state.alerts.medicineAlert;
  var auth = state.auth;
  return {
    show: alert.show,
    message: alert.message,
    planId: alert.planId,
    therapyId: alert.therapyId,
    token: auth.token,
    user: auth.user,
    rtParams: state.rtParams
  }
}

var mapDispatchToProps = (dispatch) => {
  return {
    onReceiveAlert: (message, plandId, therapyId) => {
      dispatch(showMedicineAlert(plandId, therapyId, message));
    },

    takeDosage: (planId, therapyId,token) => {
      takeDosage(planId, therapyId, token, (response, error) => {
        dispatch(hideMedicineAlert())
        if (response) {
          if (response.data.status === 'success') {
            showToast('Dosage recored successfully', 'success');
          }
          else {
            showToast(response.data.errors, 'error');
          }
        }
        else {
          showToast(SOMETHINGWRONG, 'error');
        }
      })
    },

    snoozeAlert: (planId, therapyId, token) => {
      snoozeAlert(planId, therapyId, token, (response, error) => {
        dispatch(hideMedicineAlert());
        if (response){
          if (response.data.status === 'success') {
            showToast('Dosage alert snoozed successfully', 'success');
          }
          else {
            showToast(response.data.errors, 'error');
          }
        }
        else {
          showToast(SOMETHINGWRONG, 'error')
        }
      })
    },

    closeReminder: () => {
      dispatch(hideMedicineAlert());
    }
  }
}

MedicineAlertManager = connect(mapStateToProps, mapDispatchToProps)(MedicineAlertManager);
