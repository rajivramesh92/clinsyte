class PatientChartActivitiesView extends Component {

  constructor(props) {
    super(props);
    this.state = {
      activities: [],
      isLoading: true,
      isDone: false,
      careteamMembers: props.careteamMembers,
      page: 1
    };

    this.actsWithMappedMsgs = [];
    this.filter = {
      actions: [],
      chart_items: [],
      audited_by: [],
      from_date: 'in last 30 days'
    };

    this.onSearch = this.onSearch.bind(this);
    this.loadPage = this.loadPage.bind(this);
  }

  getAction(action) {
    switch(action) {
      case 'create':
        return (
          <span>
            <strong>Added</strong> a&nbsp;
          </span>
        )
      case 'update':
        return <strong>Updated&nbsp;</strong>;
      case 'destroy':
        return (
          <span>
            <strong>Deleted</strong> a&nbsp;
          </span>
        )
    }
  }

  componentDidMount() {
    var { token, user, params, getPatientCareteam } = this.props;

    if (isPhysician(user)) {
      getPatientCareteam(params.id, token, careteam => {
        this.setState({
          careteamMembers: [careteam.patient].concat(careteam.members)
        });
      });
    }

    this.loadPage(this.state.page);
  }

  loadPage(page){
    this.setState({
      isLoading: true
    });

    var { filter, props } = this;
    var { params, token, getChartActivities } = props;
    var options = { page, filter };

    getChartActivities(params.id, token, options, activities => {
      let isDone = isLoading = false;
      if (_.isEmpty(activities)) {
        isDone = true;
      }

      var activities = page > 1 ? [...this.state.activities].concat(activities) : activities;

      this.setState({ activities, isLoading, isDone, page });
    });
  }

  componentWillUpdate(nextProps, nextState) {
    this.actsWithMappedMsgs = _.map(nextState.activities, activity => {
      var message = activity.message;
      var action = this.getAction(activity.action);
      var name = <strong>{ message.name.toLowerCase() }</strong>

      var association = <span>:&nbsp;</span>
      if(message.association) {
        association = (
          <span>
            &nbsp;in&nbsp;
            <strong>
              { message.association.name }
            </strong>
            ({ message.association.value }):
          </span>
        )
      }

      if(_.isObject(activity.message.value)) {
        var mapValues = (values, property) => {
          return (
            <span key = { property }>
              <strong>
                { property }&nbsp;
              </strong>
              from { new String(values[0]) } to { new String(values[1]) },&nbsp;
            </span>
          );
        }

        properties = _.map(activity.message.value, mapValues);
      }
      else {
        properties = <span> { activity.message.value } </span>
      }
      var newMessage = (
        <span>
          { action }
          { name }
          { association }
          { properties }
        </span>
      );
      return Object.assign({}, activity, { message: newMessage });
    });
  }

  renderActivityList(){
    var { state, loadPage, actsWithMappedMsgs } = this;
    var { page , isLoading, isDone, activities } = state;

    if (!isLoading && _.isEmpty(activities)){
      return (
        <NoItemsFound icon = 'history'
          message = 'No activities found'
        />
      );
    }

    if ( !_.isEmpty(actsWithMappedMsgs) ){
      return (
        <InfiniteScroll name = 'patient-chart-activies'
          height = { 550 }
          page = { page }
          loading = { isLoading }
          complete = { isDone }
          loadMore = { loadPage }>
          <ActivityList activities = { actsWithMappedMsgs }
            className = 'list-group'
            activityClassName = 'list-group-item'
          />
        </InfiniteScroll>
      );
    }
  }

  onSearch(filter) {
    this.filter = filter;
    this.setState({
      activities: [],
      page: 1,
      isLoading: true
    })
    this.loadPage(1);
  }

  render() {
    var user = this.props.user;
    var userSearchMembers = _.map([...this.state.careteamMembers], member => {
      return {
        ...member,
        name: member.id == user.id ? 'Me' : member.name
      };
    });

    return (
      <div>
        <h5 className = 'text-center'>
          Patient Chart Activities
        </h5>
        <div className = 'margin-top-40'>
          <ChartActivitySearch onSearchClick = { this.onSearch }
            {...{ userSearchMembers }}
          />
        </div>
        <div className = 'margin-top-40'>
          { this.renderActivityList() }
        </div>
        <div className = 'row'>
          <div className = 'col-xs-12 text-center margin-top-7'>
            { this.state.isDone && !_.isEmpty(this.state.activities) ? 'No more Activities' : '' }
          </div>
        </div>
      </div>
    )
  }
}
