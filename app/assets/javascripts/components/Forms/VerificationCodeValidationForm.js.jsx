class VerificationCodeValidationForm extends Component {

  constructor(props){
    super(props);
    this.onSubmit = this.onSubmit.bind(this);
  }

  onSubmit(event){
    event.preventDefault();

    var verificationToken = this.refs.security_code.value.trim();
    if ( verificationToken.length ){
      this.props.validateVerificationToken(verificationToken);
    }
    else{
      showToast('Verification token is required to proceed', 'error');
    }
  }

  renderResendVerification(){
    if ( this.props.resendVerificationToken ){
      return (
        <TimeoutButton className = 'button right'
          value = 'Resend code'
          onClick = { this.props.resendVerificationToken }
          timeout = '60000'
        />
      );
    }
  }

  render(){
    return (
      <div className="authform">
        <form className="verification-code-validation-form"
          onSubmit={ this.onSubmit }>
          <h4>Security Code</h4>
          <div className="form-group">
            <label htmlFor="security_code">
              Please check your inbox for a message with your code. Your code is 6 digits long.
            </label>
            <input className="form-control"
              ref="security_code"
              type="text"
              required="required"
            />
          </div>
          <div className="form-group">
            <input type="submit"
              className="button right"
              defaultValue="VERIFY"
            />
            <span className = 'right'>&nbsp;&nbsp;</span>
            { this.renderResendVerification() }
          </div>
        </form>
      </div>
    );
  }
}
