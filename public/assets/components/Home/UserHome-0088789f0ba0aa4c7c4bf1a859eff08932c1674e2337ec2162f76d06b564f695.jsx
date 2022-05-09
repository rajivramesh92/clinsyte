class UserHome extends Component {

  constructor(props) {
    super(props);
    this.state = {
      user: this.props.user,
      auth: this.props.token
    };
  }

  getUserComponent() {
    if(this.state.user) {
      var user = this.state.user;
      if (isPatient(user)) {
        return <PatientHome user = { this.state.user } />
      }
      else if (isPhysician(user)) {
        return (
          <PhysicianHome
            user = { this.state.user }
            getSummary = { this.props.getSummary }
            token = { this.state.auth }
          />
        )
      }
      else if(isAdmin(user)){
        return <AdminHome user = { this.state.user } />
      }
      else {
        return <DefaultHome user = { this.state.user } />
      }
    }
  }

  render() {
    return this.getUserComponent();
  }
}
