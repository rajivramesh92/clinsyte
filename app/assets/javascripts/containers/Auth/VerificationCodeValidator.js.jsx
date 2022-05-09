class VerificationCodeValidator extends Component {
  render(){
    return (
      <VerificationCodeValidationForm 
        validateVerificationToken = { this.props.validateVerificationToken } />
    );
  }
}

var mapDispatchToProps = (dispatch, ownProps) => {
  return {
    validateVerificationToken: (token) => {
      var params = { verification_token: token };

      var successCallback = function(response){
        if(response.data.status == 'success'){
          var query = '?token=' + response.data.data.reset_password_token;
          ownProps.history.push('/reset_password' + query);
          showToast('User is verified successfully', 'success');
        }
        else{
          showToast(response.data.errors, 'error');
        }
      }

      var errorCallback = function(error){
        showToast("Something went wrong, Please try again!", 'error');
      }

      validateVerificationCode(params, successCallback, errorCallback);
    }
  }
}

VerificationCodeValidator = connect(undefined, mapDispatchToProps)(VerificationCodeValidator);
