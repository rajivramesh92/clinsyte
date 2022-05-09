class SignInForm extends Component {

  constructor(props) {
    super(props);
    this.handleOnSubmit = this.handleOnSubmit.bind(this);
  }

  handleOnSubmit(event) {
    event.preventDefault();
    hideToast();
    var formData = {
      email: this.refs.email.value,
      password: this.refs.password.value
    }
    var errors = this.validateFormData(formData);
    if(errors.length == 0) {
      this.props.signIn(formData);
    }
    else {
      showToast(errors,'error');
    }
  }

  validateFormData(formData) {
    var errors = [];
    if(formData.email && formData.password) {
      if(!validateEmail(formData.email)){
        errors.push('Enter a valid email');
      }

      if(_.isEmpty(formData.password)) {
        errors.push('Valid password contains minimum 8 characters');
      }
    }
    else {
      errors.push('Both email and password are required to sign in');
    }
    return errors;
  }

  componentDidMount() {
    this.refs.email.focus();
  }

  render() {
    return (
      <div className = 'authform'>
        <form ref = 'loginForm'>
          <h3>Sign in</h3>
          <div className = 'form-group'>
            <Link className = 'right'
              to = '/sign_up'>
              Sign up
            </Link>
            <label htmlFor = 'user-email'>Email</label>
            <input type = 'text'
              className = 'form-control'
              ref = 'email'
              id = 'user-email'
              tabIndex = '1'
            />
          </div>
          <div className = 'form-group'>
            <Link className = 'right'
              to = '/forgot_password'>
              Forgot password?
            </Link>
            <label htmlFor = 'user-password'>Password</label>
            <input type = 'password'
              className = 'form-control'
              ref= 'password'
              id = 'user-password'
              tabIndex = '2'
            />
          </div>
          <button className = 'btn btn-primary pull-right'
            tabIndex = '3'
            onClick = { this.handleOnSubmit }>
            sign in
          </button>
        </form>
      </div>
    )
  }
}

SignInForm.propTypes = {
  signIn: PropTypes.func.isRequired
}
