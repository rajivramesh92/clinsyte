class PhoneNumberVerifier extends Component {

  constructor(props){
    super(props);
    this.verify = this.verify.bind(this);
    this.sendVerificationCode = this.sendVerificationCode.bind(this);
    this.sendVerificationCode();
  }

  verify(verificationToken){
    var phoneNumber = this.props.user.phone_number;
    this.props.validateVerificationToken(phoneNumber, verificationToken, this.props.token);
  }

  sendVerificationCode(){
    var token = this.props.token;
    initiateVerification({ field: 'phone_number' }, token, () => {
      showToast('Verification code sent successfully', 'success');
    }, () => {
      showToast('Sorry, Something went wrong, Please try again!', 'error');
    });
  }

  render(){
    return (
      <VerificationCodeValidationForm
        validateVerificationToken = { this.verify }
        resendVerificationToken = { this.sendVerificationCode } />
    );
  }
}

var mapStateToProps = (state) => {
  return {
    user: state.auth.user,
    token: state.auth.token
  }
}

var mapDispatchToProps = (dispatch, ownProps) => {
  return {
    validateVerificationToken: (phone_number, verification_token, authToken) => {
      var params = { verification_token, phone_number };

      var successCallback = function(response){
        if(response.data.status == 'success'){
          showToast('Phone number verified successfully', 'success');
          dispatch(setPhoneNumberVerified());
          ownProps.history.push('/profile/edit');
        }
        else{
          showToast(response.data.errors, 'error');
        }
      }

      var errorCallback = function(error){
        showToast("Something went wrong, Please try again!", 'error');
      }

      verifyPhoneNumber(params, authToken, successCallback, errorCallback);
    }
  };
}


PhoneNumberVerifier = connect(mapStateToProps, mapDispatchToProps)(PhoneNumberVerifier);
