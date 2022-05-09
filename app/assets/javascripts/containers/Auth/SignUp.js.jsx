class SignUp extends Component {
  render() {
    return (
      <UserForm heading = 'Sign Up'
        submitBtnValue = { 'Sign Up' }
        formType = { 'signup' }
        callback = { this.props.onSignup }
        getCurrentTimezone = { this.props.getCurrentTimezone }
      />
    )
  }
}

var mapDispatchToProps = (dispatch, ownProps) => {
  return {
    onSignup : (formData) => {
      var successCallback = (response) => {
        dispatch(setSignUpSuccess());
        dispatch(setWelcome('A message with a confirmation link has been sent to your email address. Please follow the link to activate your account'));
        ownProps.history.push('/');
      }

      var errroCallback = (error) => {
        dispatch(setSignUpError(error));
        if(error.responseJSON) {
          var errors = error.responseJSON.errors;
          showToast(errors.full_messages || errors, 'error');
        }
        else {
          showToast('Something went wrong','error');
        }
      }

      dispatch(setSignUp());
      signup({ user: formData }, successCallback, errroCallback);
    },

    getCurrentTimezone: (callback) => {
      getCurrentTimezone(timezone => {
        callback(timezone);
      });
    }
  }
};

SignUp = connect(undefined, mapDispatchToProps)(SignUp);
