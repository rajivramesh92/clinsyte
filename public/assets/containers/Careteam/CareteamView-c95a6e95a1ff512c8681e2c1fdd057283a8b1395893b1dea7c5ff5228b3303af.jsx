var mapStateToProps = (state) => {
  return {
    authToken: state.auth.token,
    user: state.auth.user,
    careteam: state.careteamWithMembers,
    careteamRequests: state.careteamRequests,
    invitationsCount: state.careteamInvitations.length
  }
}

var mapDispatchToProps = (dispatch) => {
  return {
    onRemoveMember: (careteamId, memberId, status, token) => {
      var params = { careteamId: careteamId, memberId: memberId };
      var successCallback = (response) => {
        if ( response.data && response.data.status == 'success' ){
          if( status === 'pending') {
            dispatch(removeCareteamRequest(memberId));
          }
          else {
            dispatch(removeCareteamMember(memberId));
          }
          showToast('Removed the member successfully', 'success');
        }
        else{
          showToast(SOMETHINGWRONG, 'error');
        }
      }

      var errorCallback = (error) => {
        showToast(SOMETHINGWRONG, 'error');
      }

      removeMemberFromCareteam(params, token, successCallback, errorCallback)
    },

    onSearch: (query, authToken, callback) => {
      listUsers(query, authToken, callback);
    },

    addMember: (user, member, token) => {
      createCareteamInvite(member.id, token, (response, error) => {
        if(response) {
          if(response.data.status === 'success') {

            if(!user.current_physician && isPhysician(member)) {
              dispatch(setCurrentPhysician({
                ...member,
                icon: 'pending'
              }));
            }
            dispatch(addCareteamRequest(response.data.data));
            showToast('Careteam invite sent successfully', 'success');

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

    makePrimary: (id, token) => {
      makePrimary(id, token, (response, error) => {
        if(response && response.data.status === 'success') {
          showToast('Physician role update successfully', 'success');
          dispatch(changePrimaryPhysician(id))
        }
        else {
          showToast(SOMETHINGWRONG, 'error')
        }
      })
    }

  }
}

CareteamView = connect(mapStateToProps, mapDispatchToProps)(PatientCareteamView);
