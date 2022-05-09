var mapDispatchToProps = (dispatch, ownProps) => {
  return {
    loadProfile: (token, callback) => {

    var successCallback = (response) => {
      if(response.data.status == "success") {
        callback(response.data.data)
      }
      else{
        showToast(response.data.errors, "error");
      }
    }

    var errorCallback = (error) => {
      showToast(SOMETHINGWRONG, 'error');
    }

    getBasicProfile(ownProps.params.id, token, successCallback, errorCallback);

    }
  }
}

const maptStateToProps = (state) => {
  return {
    token: state.auth.token
  }
}

UserProfile = connect(mapStateToProps, mapDispatchToProps)(UserProfileViewer);
