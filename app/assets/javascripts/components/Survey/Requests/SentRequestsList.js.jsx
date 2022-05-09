class SentRequestsList extends Component {

  constructor(props) {
    super(props);
    this.state = {
      requests: [],
      isLoading: true,
      isFetching: false,
      allRequestsLoaded: false,
      page: 1
    }
    this.filters = {
      state: [],
      receiver_id: []
    };
    this.renderRequest = this.renderRequest.bind(this);
    this.handleSearch = this.handleSearch.bind(this);
    this.loadRequests = this.loadRequests.bind(this);
  }

  componentDidMount() {
    this.loadRequests(this.state.page);
  }

  loadRequests(page) {
    this.setState({ isFetching: true });
    var { getSentRequests, token, surveyId } = this.props;
    var filters = _.map(this.filters, (value, key) =>  ({ key, value }) );
    getSentRequests(surveyId, { page, filters }, token, requests => {
      var allRequestsLoaded = isLoading = isFetching = false;
      if (_.isEmpty(requests)) {
        allRequestsLoaded = true;
      }
      this.setState({
        requests: page > 1 ? [...this.state.requests].concat(requests) : requests,
        isLoading,
        isFetching,
        allRequestsLoaded,
        page
      });
    });
  }

  handleSearch(filters) {
    var { state, receiverId } = filters;
    this.filters = {
      state: _.map(state, toLowerCase),
      receiver_id: _.map(receiverId, Number)
    };
    this.setState({
      page: 1
    });
    this.loadRequests(1);
  }

  renderRequest(request, index) {
    return (
      <li className = 'list-group-item'
        key = { request.id }>
        <div className = 'vertically-centered font-bold'>
          { index + 1}.&nbsp;
        </div>
        <div className = 'vertically-centered full-width'>
          <SentRequest request = { request }
            surveyId = { this.props.surveyId }
            className = 'row'
          />
        </div>
      </li>
    )
  }

  renderRequestsList() {
    var { requests, isLoading, isFetching, page, allRequestsLoaded } = this.state;
    if (isLoading) {
      return <PreLoader visible = { true }/>;
    }
    else if(_.isEmpty(requests)) {
      return(
        <NoItemsFound icon = { SURVEY_ICON }
          message = { 'No requests' }
        />
      );
    }
    else {
      return (
        <ul className = 'list-group margin-top-15'>
        <InfiniteScroll name = 'sent-requests'
          loadMore = { this.loadRequests }
          loading = { isFetching }
          complete = { allRequestsLoaded }
          page = { page }
          height = { 300 }
          showNoMore = { !_.isEmpty(requests) }>
            { renderItems(requests, this.renderRequest) }
        </InfiniteScroll>
        </ul>
      );
    }
  }

  render() {
    return (
      <div>
        <SentRequestSearch members = { this.props.careteamPatients }
          onSearchClick = { this.handleSearch }
          memberSelectPlaceholder = 'All the patients'
        />
        { this.renderRequestsList() }
      </div>
    )
  }
}

SentRequestsList.propTypes = {
  careteamPatients: PropTypes.array.isRequired,
  surveyId: PropTypes.oneOfType([
    PropTypes.number,
    PropTypes.string
  ])
}
