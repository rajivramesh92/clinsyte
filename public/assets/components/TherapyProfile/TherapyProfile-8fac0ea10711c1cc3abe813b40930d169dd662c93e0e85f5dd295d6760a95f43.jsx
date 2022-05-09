class TherapyProfile extends Component {

  constructor() {
    super();
    this.state ={
      therapyProfile: {}
    }
  }

  componentDidMount() {
    this.props.getTherapyProfileData(this.props.params.id, this.props.token, therapyProfile => {
      this.setState({
        therapyProfile
      });
    });
  }

  renderTherapyProfile() {
    var therapyProfile = this.state.therapyProfile;
    if (_.isEmpty(therapyProfile)) {
      return <PreLoader visible = { true } />
    }
    else {
      return (
        <div>
          <div className = 'row'>
            <div className = 'col-xs-12'>
              <h5>
                { therapyProfile.strain.name }
              </h5>
            </div>
          </div>
          <div className = 'row'>
            <div className = 'col-sm-6'>
              <TherapyCompoundChartsGroup tagsWithCompounds = { therapyProfile.tagsWithCompounds } />
            </div>
          </div>
        </div>
      );
    }
  }

  render() {
    return this.renderTherapyProfile();
  }
}
