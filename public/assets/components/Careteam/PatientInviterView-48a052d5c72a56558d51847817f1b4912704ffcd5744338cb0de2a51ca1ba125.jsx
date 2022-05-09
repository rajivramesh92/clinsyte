class PatientInviterView extends Component {

  constructor(props){
    super(props);
    this.invitePatient = this.invitePatient.bind(this);
  }

  invitePatient(event) {
    event.preventDefault();
    var patientDetails = {
      email: this.refs.email.value,
      first_name: this.refs.firstName.value,
      last_name: this.refs.lastName.value
    };

    this.props.onInvite(patientDetails, this.props.token);
    return false;
  }

  render() {
    return (
      <div className = 'row'>
        <div className = 'col-md-offset-3 col-md-6'>
          <form onSubmit = { this.invitePatient }>
            <h4>Invite New Patient</h4>
            <div className = 'form-group margin-top-40'>
              <label>First name</label>
              <input type = 'text' className = 'form-control' ref = 'firstName' />
            </div>

            <div className = 'form-group'>
              <label>Last name</label>
              <input type = 'text' className = 'form-control' ref = 'lastName' />
            </div>

            <div className = 'form-group'>
              <label>Email</label>
              <input type = 'email' className = 'form-control' ref = 'email' />
            </div>

            <div className = 'form-group'>
              <button className = 'btn btn-primary pull-right'
                onClick = { this.invitePatient }>
                Invite
              </button>
            </div>
          </form>
        </div>
      </div>
    );
  }

}
