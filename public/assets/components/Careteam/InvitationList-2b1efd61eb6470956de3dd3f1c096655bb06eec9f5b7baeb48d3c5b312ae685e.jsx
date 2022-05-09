class InvitationList extends Component {

  constructor(props){
    super(props);
    this.renderInvite = this.renderInvite.bind(this);
    this.handleClickOnReject = this.handleClickOnReject.bind(this);
    this.handleClickOnAccept = this.handleClickOnAccept.bind(this);
  }

  handleClickOnAccept(inviteId) {
    return (event) => {
      event.preventDefault();
      this.props.onAccept(inviteId, this.props.token)
    }
  }

  handleClickOnReject(inviteId) {
    return (event) => {
      event.preventDefault();
      this.props.onReject(inviteId, this.props.token)
    }
  }

  renderInvite(invite, index){
    var token = this.props.token;
    return (
      <div key={ invite.id }
       className = 'list-group-item'>
        <div className = 'vertically-centered'>
          { index + 1}.&nbsp;&nbsp;
        </div>
        <div className = 'vertically-centered full-width'>
          <div className = 'row'>
          <div className = 'col-sm-8 text-mobile-center'>
            <span className = 'blue'>
              <UserLink user = { invite.sender }/>
            </span>
          </div>
          <div className = 'col-sm-2 col-xs-6 text-center'>
            <button onClick={ this.handleClickOnAccept(invite.id) }
            className=' btn btn-link invite-actions blue'>
              <Icon icon = { ACCEPT_ICON } />&nbsp;Accept
            </button>
          </div>
          <div className = 'col-sm-2 col-xs-6 text-center'>
            <button className='btn btn-link remove-btn red'
              onClick={ this.handleClickOnReject(invite.id) }>
              <Icon icon = { REJECT_ICON }/>&nbsp;Reject
            </button>
          </div>
          </div>
        </div>
      </div>
    );
  }

  renderInvitations(){
    var invites = this.props.invites;
    if(!_.isEmpty(invites)){
      return (
        <div className='list-group'>
          { renderItems(invites, this.renderInvite) }
        </div>
      );
    }
    else {
      return (
        <NoItemsFound icon = { CARETEAM_INVITE_ICON }
          message = 'No new Invites!'
        />
      );
    }
  }

  render(){
    return (
      <div className = 'col-sm-8 col-xs-12 col-sm-offset-2'>
        <h5 className='text-center'>
          Careteam Invitations
        </h5>
        <div className = 'list-group'>
          { this.renderInvitations() }
        </div>
      </div>
    );
  }
}
