var mapStateToProps = (state) => {
  return {
    user: state.auth.user,
    token: state.auth.token
  }
};

var mapDispatchToProps = (dispatch) => {
  return {
    onInvite: (patientDetails, token) => {
      var successCallback = (response) => {
        if ( response.data && response.data.status == "success" ){
          showToast('Invite sent successfully', 'success');
          dispatch(addCareteamRequest(response.data.data));
        }
        else {
          showToast(response.data.errors, 'error');
        }
      }

      var errorCallback = (response) => {
        showToast('Sorry! Unable to send the invite.', 'error');
      }
      invitePatient(patientDetails, token, successCallback, errorCallback);
    }
  }
}

PatientInviter = connect(mapStateToProps, mapDispatchToProps)(PatientInviterView);
