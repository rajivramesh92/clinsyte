class HeaderProfileButton extends Component {

  renderListsButton() {
    return (
      <li>
        <Link className = 'right'
          to = '/lists'>
          <Icon icon = { LISTS_ICON } />&nbsp;
          Lists
        </Link>
      </li>
    );
  }

  renderMyCalendarButton() {
    return (
      <li>
        <Link className='right' to='/my_calendar'>
          <Icon icon = { CALENDAR_ICON }/>&nbsp;
          My Calendar
        </Link>
      </li>
    );
  }

  renderSurveysDropdown() {
    return (
      <li>
        <a href = '#'>
          Surveys
          <span className = 'caret'></span>
        </a>
        <ul className = 'dropdown-menu'>
          <li>
            <Link className = 'right'
              to = '/surveys'>
              <Icon icon = { SURVEY_ICON }/>&nbsp;
              Surveys
            </Link>
          </li>
          <li>
            <Link className = 'right'
              to = '/surveys/create'>
              <Icon icon = { SURVEY_ICON }/>&nbsp;
              Create Survey
            </Link>
          </li>
        </ul>
      </li>
    );
  }

  renderSlots() {
    var user = this.props.user;
    if (isPhysician(user)) {
      return (
        <li>
          <a href = '#'>
            Slots
            <span className = 'caret'></span>
          </a>
          <ul className = 'dropdown-menu'>
            { this.renderSlotManagementButton() }
            { this.renderMyCalendarButton() }
          </ul>
        </li>
      );
    }
    else if (isPatient(user)) {
      return this.renderMyCalendarButton();
    }
  }

  renderAccountOptions() {
    return (
      <ul className = 'dropdown-menu'>
        <li>
          <Link className = 'right'
            to = '/profile/change_password'>
            <Icon icon = { PASSWORD_ICON }/>&nbsp;
            Change Password
          </Link>
        </li>
        <li>
          <Link className='right'
            to='/profile/edit'>
            <Icon icon = { EDIT_ICON }/>&nbsp;
            My Account
          </Link>
        </li>
        <li>
          <Link className='right'
            to='/deactivate_account'>
            <Icon icon = { DELETE_ICON }/>&nbsp;
            Cancel Account
          </Link>
        </li>
      </ul>
    );
  }

  renderEditCareTeamButton(){
    var link, text = 'Careteams', user = this.props.user;
    if (isPatient(user)) {
      link = '/careteam';
      text = 'Edit Careteam'
    }
    else if (isPhysician(user)) {
      link = '/careteams';
    }
    else if (isAdmin(user)) {
      return;
    }
    else {
      link = '/careteams';
    }

    return (
      <li>
        <Link to = { link }>
          <Icon icon = { USERS_GROUP_ICON } />
          &nbsp;{ text }
        </Link>
      </li>
    );
  }

  renderMyHealthChartButton() {
    return (
      <li>
        <Link className = 'right'
          to = { '/users/' + this.props.user.id + '/chart'} >
          <Icon icon = { PATIENT_CHART_ICON }/>&nbsp;
          My Health Chart
        </Link>
      </li>
    )
  }

  renderSlotManagementButton(){
    return (
      <li>
        <Link className = 'right'
          to = { '/slots'} >
          <span className = 'font-size-14'>
            <Icon icon = { SLOTS_ICON }/>&nbsp;
          </span>
          My Slots
        </Link>
      </li>
    );
  }

  renderSurveyButton() {
    var user = this.props.user;

    if(isPhysician(user)) {
      link = '/surveys'
    }
    else if(isPatient(user)) {
      link = '/surveys/requests'
    }
    else {
      return;
    }

    return (
      <li>
        <Link to = { link }
        className = 'right'>
          <Icon icon = { SURVEY_ICON } />&nbsp;
          Surveys
        </Link>
      </li>
    )
  }

  render(){
    var user = this.props.user;
    return (
      <li className = 'pull-left'>
        <a href = '#'>
          <UserIcon user = { user }
            size = 'semiLarge'
          />
          <span className = 'hidden-xs'>
            &nbsp;{ user.name }
          </span>
        </a>
        <ul className = 'dropdown-menu'
          id = 'header-profile-ul'>
          { isPatient(user) ? this.renderMyHealthChartButton() : '' }
          { this.renderEditCareTeamButton() }
          { isAdmin(user) ? this.renderListsButton() : null }
          { (isAdmin(user) && !isPhysician(user)) || isStudyAdmin(user) ? this.renderSurveysDropdown() : this.renderSurveyButton() }
          { isPhysician(user) || isPatient(user) ? this.renderSlots() : null }

          <li>
            <a href = '#'>
              Account
              <span className = 'caret'></span>
            </a>
            { this.renderAccountOptions() }
          </li>

          <li role = 'separator'
          className = 'divider'></li>

          <li>
            <a href="#"
              onClick={ this.props.onSignout }>
              <Icon icon = { SIGNOUT_ICON } />&nbsp;
              Sign Out
            </a>
          </li>
        </ul>
      </li>
    )
  }
}
