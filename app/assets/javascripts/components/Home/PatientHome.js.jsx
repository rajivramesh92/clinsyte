class PatientHome extends Component {

  getSelectPhysicianButton() {
    return (
      <LinkButton to = '/careteam'
        val = 'Select Physician'
      />
    );
  }

  getIcon(){
    var icon, title;
    switch(this.props.user.current_physician.icon){
      case 'accepted':
        icon = CARETEAM_INVITE_CONFIRM_ICON;
        title = 'Careteam invite is accepted';
        className = 'green'
        break;
      case 'pending':
        icon = CARETEAM_INVITE_PENDING_ICON;
        title = 'Careteam invite is pending';
        className = 'red';
        break;
      default:
        break;
    }
    if ( !icon )
      return;
    return (
      <span className = { className }
       title = { title }>
        <Icon icon = { icon }
          size = '2Times'
        />
      </span>
    );
  }

  getCurrentPhysicianButton() {
    var currentPhysician = this.props.user.current_physician;
    return (
      <div className = 'primary-physician-btn'>
        <Link to = { '/users/' + currentPhysician.id } className = 'no-link'>
          <span className='vertically-centered'>
            <span className = { currentPhysician.icon == 'pending' ? '' : 'red' }>
              <UserIcon user = { currentPhysician }
                size = '2Times'
              />
            </span>
          </span>
          <span className='vertically-centered'>
            &nbsp;&nbsp;
          </span>
          <span className='vertically-centered font-size-15 grey'>
            { this.props.user.current_physician.name }
          </span>
          <span className='vertically-centered'>
            &nbsp;&nbsp;
          </span>
          <span className='vertically-centered'>
            { this.getIcon() }
          </span>
        </Link>
      </div>
    )
  }

  renderActionables() {
    return ( _.isEmpty(this.props.user.current_physician) ?
      this.getSelectPhysicianButton() : this.getCurrentPhysicianButton()
    );
  }

  renderActionButtons() {
    var buttonClass = 'btn btn-normal btn-block'
    var userId = this.props.user.id;
    var userActions = [
      { val: 'My Careteam', to: '/careteam' },
      { val: 'My Chart', to: '/users/' + userId + '/chart' },
      { val: 'My Surveys', to: '/surveys/requests' }
    ]

    return renderItems(userActions, (action, index) => {
      return (
        <div className = 'col-sm-2 margin-top-15'
          key = { index }>
          <LinkButton to = { action.to }
            className = { buttonClass }
            val = { action.val }
          />
        </div>
      )
    })
  }

  render() {
    return (
      <div>
        <div className = 'row'>
          <div className = 'col-md-6 col-xs-12'>
            <Greeting user = { this.props.user } />
          </div>
          <div className = 'col-md-offset-2 col-md-4 col-xs-12'>
            { this.renderActionables() }
          </div>
        </div>
        <div className = 'row'>
          <div className = 'col-xs-12'>
            { this.renderActionButtons() }
          </div>
        </div>
      </div>
    );
  }
}
