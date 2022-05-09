class PatientCareteamView extends Component {

  constructor(props){
    super(props);
    this.members = {};
    this.renderRole = this.renderRole.bind(this);
    this.getMemberMarkup = this.getMemberMarkup.bind(this);
    this.handleRemoveMember = this.handleRemoveMember.bind(this);
    this.handleMakePrimaryPhysician = this.handleMakePrimaryPhysician.bind(this);
    this.setMembers(props);
  }

  componentWillReceiveProps(nextProps){
    this.setMembers(nextProps);
  }

  setMembers(props){
    var careteamMembers = props.careteam.members;
    var requestedMembers = _.pluck(props.careteamRequests, 'recipient');
    this.members = _.groupBy(careteamMembers.concat(requestedMembers), 'role');
  }

  renderRole(role){
    return (
      <tbody key = { role }>
        <tr>
          <td colSpan = '3'>
            <h5>{ role + 's' }</h5>
          </td>
        </tr>
        { renderItems(this.members[role], this.getMemberMarkup) }
      </tbody>
    );
  }

  renderStatus(member){
    if ( member.careteam_role ){
      icon = CARETEAM_INVITE_CONFIRM_ICON
      className = 'green';
      title = 'Accepted the careteam invite';
    }
    else {
      icon = CARETEAM_INVITE_PENDING_ICON;
      className = 'red';
      title = 'Careteam invite is pending';
    }

    return (
      <span className = { className }
        title = { title }>
        <Icon icon = { icon }
          size = '2Times'
        />
      </span>
    );
  }

  handleRemoveMember(memberId, memberStatus) {
    var careteamId = this.props.careteam.id;
    var token = this.props.authToken;

    return (event) => {
      this.props.onRemoveMember(careteamId, memberId, memberStatus, token);
    }
  }


  renderCareteamRoleLabel() {
    return <small className = 'label label-success'>Primary</small>
  }

  handleMakePrimaryPhysician(memberId) {
    var token = this.props.authToken;
    return (event) => {
      event.preventDefault();
      this.props.makePrimary(memberId, token);
    }
  }

  getMemberMarkup(member){
    var token = this.props.authToken;
    var status = member.careteam_role ? '' : 'pending';
    return (
      <tr key = { 'm-' + member.id }>
        <td className = 'vertically-centered'>
          <h6>
            <UserLink user = { member }/>&nbsp;&nbsp;
            { member.careteam_role === 'primary' ? this.renderCareteamRoleLabel() : null }
          </h6>
        </td>
        <td className = 'vertically-centered text-right'>
          { this.renderStatus(member) }
        </td>
        <td className = 'vertically-centered careteamoptions-td'>
          <div className = 'dropdown pull-right'>
            <button type = 'button'
              className = 'btn btn-default dropdown-toggle'
              data-toggle = 'dropdown'>
              <Icon icon = { CARET_DOWN }/>
            </button>
            <CareteamMemberOptions member = { member }
              onRemoveMember = { this.handleRemoveMember(member.id, status) }
              onMakePrimaryPhysician = { this.handleMakePrimaryPhysician(member.id) }
            />
          </div>
        </td>
      </tr>
    );
  }

  renderRoles(){
    if ( _.isEmpty(this.members) ) {
      return <NoItemsFound message = 'No members'/>
    }
    else{
      return (
        <table className = 'table table-hover table-borderless'>
          { renderItems(_.keys(this.members), this.renderRole) }
        </table>
      );
    }
  }

  render(){
    return (
      <div>
        <div className = 'row'>
          <div className = 'col-md-8 col-md-offset-2'>
            <h5 className = 'text-center'>
              <span>My Careteam</span>
              <span className = 'pull-right'>
                <InvitationsNotifyIcon count = { this.props.invitationsCount }
                  className = 'default-color'
                />
                &nbsp;
                <ActivitiesLink to = { '/careteam/' +  this.props.careteam.id + '/activities'}/>
              </span>
            </h5>
          </div>
        </div>
        <div className = 'row margin-top-15'>
          <div className = 'col-md-8 col-md-offset-2'>
            <AddMember user = { this.props.user }
              authToken = { this.props.authToken }
              addMember = { this.props.addMember }
              onSearch =  { this.props.onSearch }
              searchableUsers = { [ 'Physician', 'Caregiver', 'Counselor', 'Support' ] }
              actionName = "Add To Care Team"
            />
          </div>
        </div>
        <div className = 'row'>
          <div className = 'col-md-8 col-md-offset-2'>
            { this.renderRoles() }
          </div>
        </div>
      </div>
    );
  }
}

PatientCareteamView.propTypes = {
  user: PropTypes.object.isRequired,
  authToken: PropTypes.object.isRequired,
  addMember: PropTypes.func.isRequired,
  onSearch: PropTypes.func.isRequired,
  careteam: PropTypes.object.isRequired,
  careteamRequests: PropTypes.array.isRequired,
  onRemoveMember: PropTypes.func.isRequired
}
