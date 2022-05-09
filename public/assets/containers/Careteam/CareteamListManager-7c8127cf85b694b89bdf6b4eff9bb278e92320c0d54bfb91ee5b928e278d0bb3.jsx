var mapStateToProps = (state) => {
  return {
    careteams: state.careteams,
    requests: state.careteamRequests,
    pendingInvitationsCount: state.careteamInvitations.length,
    user: state.auth.user,
    token: state.auth.token
  }
}

var mapDispatchToProps = (dispatch) => {
  return {
    onCareteamRemove: (careteamId, invitation, token) => {
      var params = { careteamId: careteamId };
      var successCallback = (response) => {
        if ( response.data && response.data.status === 'success' ){
          if(invitation) {
            dispatch(removeCareteamRequestUsingCareteamId(careteamId))
            var msg = 'Careteam request cancelled successfully';
          }
          else {
            dispatch(removeCareteam(careteamId));
            var msg = 'You are removed from the careteam successfully';
          }
          showToast(msg, 'success');
        }
      };

      var errorCallback = (error) => {
        showToast(SOMETHINGWRONG, 'error');
      };

      removeMemberFromCareteam(params, token, successCallback, errorCallback);
    },

    onAddCareteam: (currentUser, selectedUser, token) => {
      createCareteamInvite(selectedUser.id, token, (response, error) => {
        if (response) {
          if (response.data.status === 'success') {
            showToast('Careteam Invited Sent successfully', 'success');
            dispatch(addCareteamRequest(response.data.data));
          }
          else {
            showToast(response.data.errors, 'error');
         }
        }
        else {
          showToast(SOMETHINGWRONG, 'error');
        }
      });
    },

    onSearch: (query, authToken, callback) => {
      listUsers(query, authToken, callback);
    },
  }
}

CareteamListManager = connect(mapStateToProps, mapDispatchToProps)(PhysicianCareteamsView);
