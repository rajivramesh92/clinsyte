class ResendConfirmationForm extends Component {

  constructor(props) {
    super(props);
    this.handleOnSubmit = this.handleOnSubmit.bind(this);
  }

  handleOnSubmit(event) {
    event.preventDefault();
    var email = this.refs.email.value.trim();
    if(email.length && validateEmail(email)) {
      this.props.resendConfirmation(email);
    }
    else {
      showToast('Enter a valid email', 'error');
    }
  }

  render() {
    return (
      <div className = 'authform'>
        <form onSubmit = { this.handleOnSubmit }>
          <h5 className = 'text-center'>
            Resend Confirmation Instructions
          </h5>
          <br />
          <div className = 'form-group'>
            <input type = 'email'
              className = 'form-control'
              ref = 'email'
              id = 'resend-email'
              required = 'required'
              placeholder = 'Email address'
            />
          </div>
          <div className = 'form-group'>
            <button type = 'submit'
              className = 'button right'>
              SUBMIT
            </button>
          </div>
        </form>
      </div>
    )
  }
}
