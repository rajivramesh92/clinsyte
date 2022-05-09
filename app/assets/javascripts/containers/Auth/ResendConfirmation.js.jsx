var mapDispatchToProps = (dispatch, ownProps) => {
  return {
    resendConfirmation: (email) => {
      var successCallback = function(response){
        if ( response.data.status == 'success' ){
          showToast(response.data.data, 'success');
          ownProps.history.push('/');
        }
        else{
          showToast(response.data.errors, 'error');
        }
      }

      var errorCallback = function(error){
        showToast('Something went wrong!', 'error');
      }

      resendConfirmationEmail(email, successCallback, errorCallback);
    }
  }
}

ResendConfirmation = connect(undefined, mapDispatchToProps)(ResendConfirmationForm);
