class PasswordResetForm extends Component{
  constructor(props){
    super(props);
    this.handleForm = this.handleForm.bind(this);
    this.passwordElements = [
      { id: 'password', ref: 'password', display: 'Password' },
      { id: 'password-confirmation', ref: 'passwordConfirmation', display: 'Password Confirmation' }
    ];
  }

  componentDidMount(){
    this.resetPasswordToken = this.props.location.query.token;
  }

  validateForm(){
    var password = this.refs.password.value.trim();
    var passwordConfirmation = this.refs.passwordConfirmation.value.trim();

    if( password.length && passwordConfirmation.length ){
      if ( password == passwordConfirmation ){
        return true;
      }
      else{
        showToast('Password and password confirmation must be same', 'error');
        return false;
      }
    }
    showToast('Please enter password and password confirmation to proceed', 'error');
  }

  handleForm(event){
    event.preventDefault();

    if(this.validateForm()){
      var params = {
        password: this.refs.password.value,
        password_confirmation: this.refs.passwordConfirmation.value,
        reset_password_token: this.resetPasswordToken
      };

      if(params.password == params.password_confirmation){
        this.props.resetPassword(params)
      }
      else{
        showToast("Password and Password Confirmation must be same", 'error');
      }
    }
  }

  renderPasswordFields() {
    return renderItems(this.passwordElements, pwdElement => {
      return (
        <div key = { pwdElement.id }>
          { getPasswordField(pwdElement.id, pwdElement.ref, pwdElement.display) }
        </div>
      )
    })
  }

  render(){
    return (
      <div className="authform">
        <form className='password-reset-form'
          onSubmit={ this.handleForm }>
          <h4>Reset Password</h4>
          { this.renderPasswordFields() }
          <input type="submit"
            className="button right"
            defaultValue="RESET PASSWORD"
          />
        </form>
      </div>
    );
  }
}
