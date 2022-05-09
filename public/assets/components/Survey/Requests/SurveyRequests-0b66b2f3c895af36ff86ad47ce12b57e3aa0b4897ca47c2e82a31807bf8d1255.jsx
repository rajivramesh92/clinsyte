class SurveyRequests extends Component {

  constructor(props) {
    super(props);
    var surveys = this.props.surveys;
    this.state = {
      surveys: surveys,
      page: parseInt(surveys.length / 10) + 1,
      isFetching: false,
      allRequestsLoaded: _.isEmpty(surveys),
    }
    this.filters = [];

    this.loadSurveys = this.loadSurveys.bind(this);
    this.handleSearch = this.handleSearch.bind(this);
  }

  componentWillReceiveProps(nextProps, prevProps) {
    this.setState({
      surveys: nextProps.surveys || prevProps.surveys
    });
  }

  loadSurveys(page) {
    this.setState({ isFetching: true });
    var { getSurveyRequests, token } = this.props;
    var filters = _.map(this.filters, (value, key) => ({ key, value }));
    getSurveyRequests({ filters, page }, token, surveys => {
      var isFetching = allRequestsLoaded = false;
      if (_.isEmpty(surveys)) {
        allRequestsLoaded = true;
      }
      this.setState({ isFetching, allRequestsLoaded, page });
    });
  }

  handleSearch(filters) {
    var { state, receiverId } = filters;
    this.filters = {
      state: _.map(state, toLowerCase),
      sender_id: _.map(receiverId, Number)
    };
    this.setState({
      surveys: [],
      page: 1
    });
    this.loadSurveys(1);
  }

  render() {
    var { page, surveys, isFetching, allRequestsLoaded } = this.state;
    return (
      <div>
        <div className = 'col-sm-10 col-sm-offset-1'>
          <div className = 'row'>
            <div className = 'col-xs-12'>
              <h5 className = 'text-center'>Surveys</h5>
            </div>
          </div>
          <div className = 'row'>
            <SentRequestSearch onSearchClick = { this.handleSearch }
              members = { this.props.careteamMembers }
              memberSelectPlaceholder = 'All the careteam physicians'
            />
            <div className = 'margin-top-15'></div>
            <InfiniteScroll name = 'survey-requests'
              height = { 300 }
              complete = { allRequestsLoaded }
              showNoMore = { !_.isEmpty(surveys) }
              loading = { isFetching }
              page = { page }
              loadMore = { this.loadSurveys }>
                <RequestsList surveys = { surveys }/>
            </InfiniteScroll>
          </div>
        </div>
      </div>
    )
  }
}

SurveyRequests.propTypes = {
  surveys: PropTypes.array.isRequired
}
