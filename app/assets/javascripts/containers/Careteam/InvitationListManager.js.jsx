var mapStateToProps = (state) => {
  return {
    invites: state.careteamInvitations,
    token: state.auth.token
  }
}

var mapDispatchToProps = (dispatch) => {

  var getSuccessCallback = (action, inviteId, inviteResponse) => {
    return (response) => {
      if ( response.data && response.data.status === 'success' ){
        showToast('Careteam member invite ' + inviteResponse + ' successfully', 'success');
        dispatch(action);
        if (inviteResponse === 'accepted') {
          var newCareteam = {
            id: null,
            patient: response.data.data.sender
          };
          dispatch(addCareteam(newCareteam));
        }
      }
      else{
        showToast(response.data.errors, 'error');
      }
    }
  }

  var getErrorCallback = () => {
    showToast(SOMETHINGWRONG, 'error');
  }

  return {
    onAccept: (inviteId, token) => {
      acceptCareteamInvite(inviteId, token, getSuccessCallback(removeCareteamInvite(inviteId), inviteId, 'accepted'), getErrorCallback);
    },

    onReject: (inviteId, token) => {
      declineCareteamInvite(inviteId, token, getSuccessCallback(removeCareteamInvite(inviteId), inviteId, 'declined'), getErrorCallback);
    }
  };
}

InvitationListManager = connect(mapStateToProps, mapDispatchToProps)(InvitationList);
