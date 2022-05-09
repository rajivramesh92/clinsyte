class AddMember extends Component {

  constructor(props) {
    super(props);
    this.state = {
      placeholder: this.getPlaceholder(props.defaultRole)
    }
    this.onRoleChange = this.onRoleChange.bind(this);
    this.suggestionSource = this.suggestionSource.bind(this);
    this.onAddMember = this.onAddMember.bind(this);
    this.onUserSelect = this.onUserSelect.bind(this);
  }

  onAddMember(event) {
    event.preventDefault();
    var selectedUser = this.state.selectedUser;
    var currentUser = this.props.user
    var token = this.props.authToken;
    if (selectedUser) {
      this.props.addMember(currentUser, selectedUser, token)
    }
    else {
      showToast('Please select a user to proceed', 'error')
    }
  }

  onUserSelect(event, suggestion) {
    this.setState({ selectedUser: suggestion })
  }

  onRoleChange(memberType) {
    var placeholder = this.getPlaceholder(memberType);
    this.refs.memberAutoSuggest.clearValue();
    this.setState({
      placeholder
    })
  }

  getPlaceholder(memberType) {
    return 'Search ' + (memberType || 'User') + 's...';
  }

  getSearchOptions() {
    return _.map(this.props.searchableUsers, option => {
      return {
        value: option,
        key: option,
        display: option
      }
    }).concat({ key: 'all', display: 'All', value: '' })
  }

  searchUser(query, token, callback) {
    var authToken = this.props.authToken;

    this.props.onSearch(query, authToken, (response, error) => {
      this.setState({
        isSearchInProgress: false
      });

      if(response.data.status && response.data.status.toLowerCase() === 'success') {
        callback(response.data.data);
      }
      else {
        showToast(SOMETHINGWRONG, 'error');
      }
    });
  }

  suggestionSource(queryValue, syncCallback, asyncCallback) {
    var onKeyUp = () => {
      var query = {
        value: queryValue,
        roles: this.refs.roles.getValue()
      }
      var token = this.props.authToken;

      clearTimeout(this.keyPressTimeout);

      this.keyPressTimeout = setTimeout(() => {
        this.setState({ isSearchInProgress: true });
        this.searchUser(query, token, asyncCallback);
      }, 1000);
    }

    var onKeyDown = () => {
      clearTimeout(this.keyPressTimeout);
    }

    $('.typeahead').on('keyup', onKeyUp);
    $('.typeahead').on('keydown', onKeyDown);
  }

  suggestionTemplate(user) {
    return React.renderToString(
      <div className = 'col-xs-12 add-member-suggestion'>
        <div className = 'col-xs-8 font-bold'>
          <UserIcon user = { user }/>
          &nbsp; &nbsp;
          { user.name }
        </div>
        <div className = 'col-xs-4'>
          { user.gender }
        </div>
      </div>
    )
  }

  render() {
    return (
      <div className = 'row'>
        <div className = 'col-sm-3 margin-top-15'>
          <div className = 'form-group'>
            <DropDown disabled = { this.props.disableRoleOptions }
              options = { this.getSearchOptions() }
              defaultVal = { this.props.defaultRole || '' }
              onChange = { this.onRoleChange }
              ref = 'roles'
              className = 'form-control'
            />
          </div>
        </div>
        <div className = 'col-sm-6 margin-top-15 '>
          <AutoSuggest source = { this.suggestionSource }
            placeholder = { this.state.placeholder }
            name = 'member-search'
            className = 'form-control'
            suggestionTemplate = { this.suggestionTemplate }
            displayKey = { (user) => { return user.name } }
            onSelectHandler = { this.onUserSelect }
            isLoading = { this.state.isSearchInProgress }
            ref = 'memberAutoSuggest'
          />
        </div>
        <div className = 'col-sm-3 margin-top-15'>
          <div className = 'form-group'>
            <button className = 'btn btn-primary form-control'
              onClick = { this.onAddMember }>
              { this.props.actionName }
            </button>
          </div>
        </div>
      </div>
    )
  }
}

AddMember.propTypes = {
  searchableUsers: PropTypes.array.isRequired,
  onSearch: PropTypes.func.isRequired,
  addMember: PropTypes.func.isRequired,
  user: PropTypes.object.isRequired,
  authToken: PropTypes.object.isRequired,
  disableRoleOptions: PropTypes.bool,
  defaultRole: PropTypes.string.isRequired
}
