class ChangePassword extends Component {
  constructor(){
    super();
    this.changePassword = this.changePassword.bind(this);
  }

  changePassword(currentPassword, password, passwordConfirmation){
    var data = {
      current_password: currentPassword,
      password: password,
      password_confirmation: passwordConfirmation
    };

    var callback = (response, error) => {
      if(response){
        if(response.data.status == 'success'){
          showToast('Password updated succcessfully', 'success');
        }
        else{
          showToast(response.data.errors[0], 'error')
        }
      }
      else{
        showToast('Something went wrong', 'error');
      }
    };
    showToast('Please wait...', 'success');
    updateProfile(data, this.props.user.id, this.props.authToken, callback);
  }

  render(){
    return (
      <ChangePasswordForm changePassword={ this.changePassword } />
    );
  }
}

var mapStateToProps = (state) => {
  return {
    authToken: state.auth.token,
    user: state.auth.user
  }
}

ChangePassword = connect(mapStateToProps)(ChangePassword);
