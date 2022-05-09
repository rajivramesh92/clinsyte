var mapDispatchToProps = (dispatch, ownProps) => {
  return {
    sendVerificationCode: (params) => {
      var successCallback = (response) => {
          if(response.data.status == 'success'){
            ownProps.history.push('/validate_verification_code');
            showToast('Verification code sent successfully', 'success');
          }
          else{
            showToast(response.data.errors, 'error');
          }
        }

      var errorCallback = (error) => {
          showToast('Something went wrong. Please try again!', 'error')
        }

      sendVerificationCode(params, successCallback.bind(), errorCallback.bind());
    }
  }
}

RecoverPassword = connect(undefined, mapDispatchToProps)(PasswordRecoveryForm)
