class CareteamList extends Component {

  constructor(props){
    super(props);
    this.renderCareteam = this.renderCareteam.bind(this);
    this.handleClickOnRemove = this.handleClickOnRemove.bind(this);
    this.renderInvitePatientLink = this.renderInvitePatientLink.bind(this);
  }

  getPendingCareteamsMarkup(patient) {
    return (
      <span className = 'default-color'>
        { patient.name }&nbsp;
        <small className = 'label label-danger'>
          Pending
        </small>
      </span>
    );
  }

  getCareteamsFromRequests(requests) {
    return _.map(this.props.requests, request => {
      return {
        id: request.recipient.careteam_id,
        patient: request.recipient,
        status: 'pending'
      };
    });
  }

  handleClickOnRemove(careteamId, careteamStatus) {
    return (event) => {
      this.props.onCareteamRemove(careteamId, Boolean(careteamStatus), this.props.token);
    }
  }

  renderLeaveCareteamId(careteamId, careteamStatus) {
    if (careteamId) {
      return (
        <span onClick = { this.handleClickOnRemove(careteamId, careteamStatus) }
          className = 'red cursor-pointer font-size-18 margin-left-20'
          title = 'Leave Careteam'>
          <Icon icon = { DELETE_ICON }/>
        </span>
      );
    }
  }

  renderCareteam(careteam, index){
    return (
      <div className = 'list-group-item'
        key = { index }>
        <div className = 'display-table-cell font-bold'>
          { index + 1}.&nbsp;
        </div>
        <div className = 'vertically-centered full-width blue'>
          { careteam.status === 'pending' ? this.getPendingCareteamsMarkup(careteam.patient)  : <ChartLink user = { careteam.patient }/> }
          <span className = 'pull-right'>
            <PatientProfileLink user = { careteam.patient }/>&nbsp;
            { this.renderLeaveCareteamId(careteam.id, careteam.status) }
          </span>
        </div>
      </div>
    )
  }

  renderPendingInvitationsCount() {
    var count = this.props.pendingInvitationsCount;
    if( count > 0 ) {
      return (
        <span className = 'notifcount-header invite-count'>
          { count }
        </span>
      )
    }
  }

  renderCareteams() {
    var pendingCareteams = this.getCareteamsFromRequests(this.props.requests);
    var allCareteams = [...this.props.careteams].concat(pendingCareteams);

    if ( _.isEmpty(allCareteams) ){
      return (
        <NoItemsFound icon = { USERS_GROUP_ICON }
          message = 'No careteam found!'
        />
      );
    }

    return renderItems(allCareteams, this.renderCareteam);
  }

  renderInvitePatientLink() {
    if ( this.props.isPhysician ){
      return (
        <Link to = '/careteams/invite_patient'
          className = 'btn btn-primary btn-sm pull-right'>
          Invite New Patient
        </Link>
      );
    }
    return null;
  }

  render(){
    return (
      <div>
        <div className = 'row'>
          <div className = 'col-sm-8 col-sm-offset-2'>
            <h5 className = 'text-center'>
              <div>
                Careteams
                { this.renderInvitePatientLink() }
                <span className = 'pull-right'>&nbsp;&nbsp;</span>
                <InvitationsNotifyIcon count = { this.props.pendingInvitationsCount }
                  className = 'no-link pull-right'
                />
              </div>
            </h5>
          </div>
        </div>
        <div className = 'row'>
          <div className = 'col-sm-8 col-sm-offset-2'>
            <div className = 'list-group'>
              { this.renderCareteams() }
            </div>
          </div>
        </div>
      </div>
    );
  }
}
