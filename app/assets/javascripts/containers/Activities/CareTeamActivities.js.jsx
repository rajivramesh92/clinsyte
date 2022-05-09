class CareTeamActivities extends Component {

  constructor(props) {
    super(props);
    this.state = {
      activities: [],
      isLoading: true,
      isDone: false
    }
    this.page = 1;
    this.actsWithMappedMsgs = undefined;
    this.filter = {
      actions: [],
      from_date: 'in last 30 days'
    }

    this.onSearch = this.onSearch.bind(this);
  }

  componentDidMount() {
    $(window).scroll(() => {
      if ( ($(window).scrollTop() == $(document).height() - $(window).height()) && !this.state.isLoading && !this.state.isDone ) {
        this.page += 1;
        this.loadPage();
      }
    }.bind(this));
    this.loadPage();
  }

  getAction(action) {
    switch(action) {
      case 'create':
        return <strong>Added </strong>;
      case 'update':
        return <strong>Updated role of </strong>;
      case 'destroy':
        return <strong>Deleted </strong>;
    }
  }

  getPronounForUser() {
    return this.props.user.gender === 'male' ? 'his' : 'her';
  }

  loadPage() {
    var careteamId = this.props.params.id;
    var token = this.props.token;
    var options = {
      page: this.page,
      filter: this.filter
    }
    getCareTeamActivities(careteamId, token, options, (response, error) => {
      if(response) {
        if(response.data.status.toLowerCase() === 'success') {
          var newState = { isLoading: false };
          if( _.isEmpty(response.data.data) )
            newState['isDone'] = true;
          else
            newState['activities'] = _.union(this.state.activities, response.data.data);
          this.setState(newState);
        }
        else {
          showToast(response.data.data.errors, 'error');
        }
      }
      else {
        showToast(SOMETHINGWRONG, 'error');
      }
    })
  }

  componentWillUpdate(nextProps, nextState) {
    this.actsWithMappedMsgs = _.map(nextState.activities, activity => {
      var message = activity.message;
      var action = this.getAction(activity.action);
      var name = (
        <span>
          <strong>
            { activity.action === 'update' ? activity.message.association : message.value.member.name }
          </strong>&nbsp;
          { activity.action === 'delete' ? 'from' : 'in' }&nbsp;
          { this.getPronounForUser() } care team.
        </span>
      )

      var newMessage = (
        <span>
          { action }
          { name }
        </span>
      )
      return Object.assign({}, activity, { message: newMessage })
    })
  }

  renderActivityList(){
    if ( this.state.isLoading ){
      return <PreLoader visible = { true } />
    }

    if ( !_.isUndefined(this.actsWithMappedMsgs) ){
      return (
        <ActivityList activities = { this.actsWithMappedMsgs }
          className = 'list-group'
          activityClassName = 'list-group-item'
        />
      );
    }
  }

  onSearch(filter) {
    this.filter = filter;
    this.setState({
      activities: []
    })
    this.page = 1;
    this.loadPage();
  }

  render() {
    var activities = this.state.activities;
    var isDone = this.state.isDone;
    return (
      <div>
        <h5 className = 'text-center'>
          Careteam History
        </h5>
        <div className = 'margin-top-40'>
          <CareTeamActivitySearch onSearchClick = { this.onSearch }/>
        </div>
        <div className = 'margin-top-40'>
          { this.renderActivityList() }
        </div>
        <div className = 'row'>
          <div className = 'col-xs-12 text-center margin-top-7'>
            { isDone && !_.isEmpty(activities) ? 'No more Activities' : '' }
          </div>
        </div>
      </div>
    );
  }

  componentWillUnmount() {
    $(window).off('scroll');
  }
}

var mapStateToProps = (state) => {
  return {
    token: state.auth.token,
    user: state.auth.user
  }
}

CareTeamActivities = connect(mapStateToProps)(CareTeamActivities);
