class ChangePasswordForm extends Component {

  constructor(){
    super();
    this.passwordElementsConfig = [
      { id: 'current-password', ref: 'currentPassword', display: 'Current Password'},
      { id: 'password', ref: 'password', display: 'Password' },
      { id: 'password-confirmation', ref: 'passwordConfirmation', display: 'Password Confirmation' }
    ];
    this.handleOnClick = this.handleOnClick.bind(this);
  }

  clearForm() {
    this.refs.currentPassword.value = '';
    this.refs.password.value = '';
    this.refs.passwordConfirmation.value = '';
  }

  renderPasswordElement(passwordElementConfig){
    return (
      <div key = { passwordElementConfig.id }>
        { getPasswordField(passwordElementConfig.id, passwordElementConfig.ref, passwordElementConfig.display) }
      </div>
    );
  }

  handleOnClick(event){
    event.preventDefault();
    var currentPassword = this.refs.currentPassword.value.trim(),
      password = this.refs.password.value.trim(),
      passwordConfirmation = this.refs.passwordConfirmation.value.trim();

    if ( currentPassword.length && password.length && passwordConfirmation.length ){
      if ( password == passwordConfirmation ){
        this.props.changePassword(currentPassword, password, passwordConfirmation);
        this.clearForm();
      }
      else{
        showToast('Password and Password Confirmation should be same', 'error');
      }
    }
    else{
      showToast('Please fill all the fields', 'error');
    }
  }

  render() {
    return (
      <form ref = 'changePasswordForm'
        className ='authform'>
        <h4>Change Password</h4>
        { renderItems(this.passwordElementsConfig, this.renderPasswordElement) }
        <div className='form-group'>
          <button onClick = { this.handleOnClick }
            className = 'btn btn-primary std-btn pull-right'>
            change
          </button>
        </div>
      </form>
    )
  }
}
