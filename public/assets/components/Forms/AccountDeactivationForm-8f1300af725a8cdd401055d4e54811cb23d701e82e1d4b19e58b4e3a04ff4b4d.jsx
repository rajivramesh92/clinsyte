class AccountDeactivationForm extends Component {

  constructor(props){
    super(props);
    this.handleClickOnDeactivate = this.handleClickOnDeactivate.bind(this);
  }

  componentDidMount() {
    this.refs.password.focus();
  }

  handleClickOnDeactivate(event){
    event.preventDefault();
    var password = this.refs.password.value.trim();
    var props = this.props;

    if ( _.isEmpty(password) ){
      showToast('Please enter password to proceed', 'error');
    }
    else{
      this.props.deactivateAccount(password, props.user.id, props.token);
    }
  }

  render(){
    return (
      <div className="authform">
        <form>
          <h4>Account Deactivation</h4>
          <div className="form-group">
            <label>
              Are you sure you want to delete the account?
            </label>
          </div>
          <div className="form-group">
            <label htmlFor="password">
              Password
            </label>
            <input type="password"
              className="form-control"
              id="password"
              required="required"
              ref="password"
            />
          </div>
          <div className="form-group">
            <LinkButton to = '/home'
              val = 'Return to home'
              className = 'pull-left btn btn-default'>
            </LinkButton>
            <button onClick = { this.handleClickOnDeactivate }
            className = 'btn btn-primary std-btn pull-right'>
              cancel
            </button>
          </div>
        </form>
      </div>
    );
  }
}

AccountDeactivationForm.propTypes = {
  token: PropTypes.object.isRequired,
  deactivateAccount: PropTypes.func.isRequired,
  user: PropTypes.object.isRequired
}
