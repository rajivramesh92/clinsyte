var mapDispatchToProps = (dispatch, ownProps) => {
  return {

    deactivateAccount: (password, userId, token) => {
      var params = { password };

      var successCallback = (response) => {
        if(response.data.status == "success"){
          dispatch(setLogoutSuccess());
          ownProps.history.push('/');
          showToast('Account has been cancelled', 'success');
        }
        else{
          showToast(response.data.errors, 'error');
        }
      }

      var errorCallback = (error) => {
        showToast(SOMETHINGWRONG, 'error');
      }

      deleteAccount(params, userId, token, successCallback, errorCallback);
    }
  }
}

var mapStateToProps = (state) => {
  return {
    token: state.auth.token,
    user: state.auth.user
  }
}

AccountDeactivator = connect(mapStateToProps, mapDispatchToProps)(AccountDeactivationForm);
