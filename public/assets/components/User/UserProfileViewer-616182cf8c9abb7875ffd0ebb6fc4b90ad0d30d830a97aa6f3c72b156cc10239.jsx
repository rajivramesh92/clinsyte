class UserProfileViewer extends Component {

  constructor(props) {
    super(props);
    this.state = {
      profile: {}
    }
  }

  componentDidMount(){
    this.props.loadProfile(this.props.token, profile => {
      this.setState({
        profile
      })
    });
  }

  renderAppointmentLink(userId) {
    return (
      <Link to = { '/users/' + userId + '/calendar' }>
        <span title = 'Schedule an Appointment'>
          <Icon icon = { APPOINTMENT_REQUEST_ICON }/>
        </span>
      </Link>
    )
  }

  render() {
    var profile = this.state.profile || {};
    var genderIcon = {
      male: MALE_ICON,
      female: FEMALE_ICON
    };
    if(_.isEmpty(profile)) {
      return <PreLoader visible = { _.isEmpty(profile) }/>
    }
    return(
      <div className = 'row'>
        <div className = 'col-sm-6 col-xs-offset-3 margin-top-15'>
          <h5>
            <span className = 'blue'>
              <UserIcon user = { profile }/>
              &nbsp;&nbsp;&nbsp;
            </span>
            { profile.name }
            <span className = 'pull-right'>
              { isPhysician(profile) ? this.renderAppointmentLink(profile.id) : ''}
            </span>
          </h5>
        </div>
        <div className = 'col-sm-6 col-sm-offset-3 margin-top-15'>
        <div className = 'list-group blue font-size-15'>
          <div className = 'list-group-item'>
            <Icon icon = { MOBILE_ICON }/>
            &nbsp;&nbsp;&nbsp;
            { profile.phone_number }
          </div>
          <div className = 'list-group-item'>
            <Icon icon = { EMAIL_ICON }/>
            &nbsp;&nbsp;&nbsp;
            <Link to = { 'mailto:' + profile.email }>
              { profile.email }
            </Link>
          </div>
          <div className = 'list-group-item'>
            <Icon icon = { ETHINICITY_ICON }/>
            &nbsp;&nbsp;&nbsp;
            { profile.ethnicity }
          </div>
          <div className = 'list-group-item'>
            <Icon icon = { genderIcon[profile.gender] }/>
            &nbsp;&nbsp;&nbsp;
            { capitalize(profile.gender) }&nbsp;
            <sub>({ getAge(profile.birthdate) })</sub>
          </div>
        </div>
        </div>
      </div>
    );
  }
}

UserProfileViewer.propTypes = {
  loadProfile: PropTypes.func.isRequired,
  token: PropTypes.object.isRequired
}
