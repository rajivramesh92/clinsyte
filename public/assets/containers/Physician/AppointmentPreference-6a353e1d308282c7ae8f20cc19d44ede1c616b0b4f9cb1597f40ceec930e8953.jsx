const mapStateToProps = (state) => {
  return {
    autoConfirm: state.appointmentPreference.autoConfirm,
    token: state.auth.token
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    toggleAutoConfirm: (autoConfirm, token) => {
      updateAutoConfirm(autoConfirm, token, (response, error) => {
        if(response) {
          if(response.data.status.toLowerCase() === 'success') {
            showToast(response.data.data, 'success');
            dispatch(toggleAutoConfirm(autoConfirm));
          }
          else {
            showToast(response.data.errors, 'error')
          }
        }
        else {
          showToast('Unexpected error have occured', 'error');
        }
      })
    }
  }
}

var AppointmentPreferences = connect(mapStateToProps,mapDispatchToProps)(AutoConfirmSwitch)
