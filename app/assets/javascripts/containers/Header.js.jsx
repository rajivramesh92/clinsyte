var mapStateToProps = (state) => {
  return {
    authToken: state.auth.token,
    user: state.auth.user,
    qrImgString: state.qrCode.imgString,
    notificationCount: state.notifications.length
  };
}

var mapDispatchToProps = (dispatch, ownProps) => {
  return {
    onSignout: (authToken) => {
      var successCallback = (response) => {
        if ( response.data && response.data.success ){
          localStorage.clear();
          if(PrivatePub.fayeClient){
            PrivatePub.fayeClient.disconnect();
          }
          ownProps.history.push('/sign_out');
          dispatch(setLogoutSuccess());
          dispatch(unSetRtParams());
          PrivatePub = buildPrivatePub(document)
          showToast('Signed out successfully', 'success');
          ownProps.history.push('/');
        }
      }

      var errorCallback = (error) => {
        showToast('Something went wrong, Please reload and try again!', 'error');
      }

      signOut( authToken, successCallback, errorCallback );
    }
  }
}

Header = connect(mapStateToProps, mapDispatchToProps)(Navbar);
