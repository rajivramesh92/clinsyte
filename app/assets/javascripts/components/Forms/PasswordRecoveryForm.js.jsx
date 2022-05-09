class PasswordRecoveryForm extends Component {

  constructor(props){
    super(props);
    this.handleForm = this.handleForm.bind(this);
  }

  validateForm(){
    var medium = this.refs.medium.value.trim();
    return medium.length;
  }

  handleForm(event){
    event.preventDefault();
    if(this.validateForm()){
      var params = {
        medium: this.refs.medium.value
      };
      this.props.sendVerificationCode(params);
    }
    else{
      showToast('Please enter email or phone number to proceed', 'error');
    }
  }

  render(){
    return (
      <div className="authform">
        <form className="password-recovery-form"
          onSubmit={ this.handleForm }>
          <h4>Forgot your password?</h4>
          <div className="form-group">
            <label htmlFor="medium">
              Email or Phone number
            </label>
            <input type="text"
              className="form-control"
              ref="medium"
            />
          </div>
          <input type="submit"
            className="button right"
            defaultValue="Send Verification Code"
          />
        </form>
      </div>
    );
  }
}
