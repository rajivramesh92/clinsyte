var mapDispatchToProps = (dispatch, ownProps) => {
  return {
    signIn: (data) => {
        showToast('Please Wait...', 'success');
        login(data, (response, error) => {
          if(response) {
            dispatch(setLogInSuccess(response.headers));
            var data = response.data.data;
            dispatch(setRtParams(data.rt_params));
            dispatch(setUser(data.auth.user));
            dispatch(setNotifications(data.notifications));
            dispatch(setCareteamInvites(data.careteamInvitations));
            dispatch(setCareteams(data.careteams));
            dispatch(setSignedInFirstTime(data.auth.signedInFirstTime));
            dispatch(loadCareteam(data.careteamWithMembers));
            dispatch(setCareteamRequests(data.careteamRequests));
            dispatch(setLists(data.lists));
            if(data.qrCode){
              dispatch(setQRImgString(data.qrCode.imgString));
            }
            dispatch(setSurveys(data.surveys));

            localStorage.setItem('authHeaders',JSON.stringify(response.headers));
            showToast('Signed in successfully', 'success');
            if ( data.auth.signedInFirstTime && isPhysician(data.auth.user) ){
              ownProps.history.push('/slots?sign_up=true');
            }
            else{
              ownProps.history.push('/home');
            }
          }
          if(error) {
            showToast(error.responseJSON.errors[0], 'error', 5000);
            dispatch(setLogInError(error));
          }
        })
      }
    }
  }

SignIn = connect(undefined, mapDispatchToProps)(SignInForm);
