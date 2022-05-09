var mapDispatchToProps = (dispatch, ownProps) => {
  return {
    resetPassword: (params) => {
      var successCallback = (response) => {
        if(response.data.status == 'success'){
          ownProps.history.push('/');
          showToast('Password updated successfully', 'success');
        }
        else{
          showToast(response.data.errors);
        }
      }

      var errorCallback = (error) => {
        showToast('Something went wrong. Please try again!', 'error');
      }
      resetPassword(params, successCallback, errorCallback)
    }
  }
}

ResetPassword = connect(undefined, mapDispatchToProps)(PasswordResetForm);
