/**
 * renders Questions and list of sent request related to given survey
 * @type {React Component}
 */
class SurveyView extends Component {

  constructor(props) {
    super(props);
    this.state = {
      survey: { questions: [] },
      view: 'questions',
      isFetching: true
    }
    this.views = ['questions', 'requests'];
    this.handleViewChangeClick = this.handleViewChangeClick.bind(this);
  }

  componentDidMount() {
    var { token, params } = this.props;
    this.props.getSurvey(token, params.id, survey => {
      this.setState({
        survey,
        isFetching: false
      })
    })
  }

  handleViewChangeClick(eventKey) {
    this.setState({
      view: viewMap[Number(eventKey) - 1]
    });
  }

  renderSurveyQuestions() {
    var { token, user, getQuestionStats, patients } = this.props;
    var survey = this.state.survey;
    return (
      <div className = 'margin-top-15'>
        <SurveyResultsDashBoard questions = { survey.questions }
          token = { token }
          getQuestionStats = { getQuestionStats }
          patients = { patients }
          showStats = { isPhysician(user) || isAdmin(user) || isStudyAdmin(user) }
        />
      </div>
    );
  }

  renderSentRequestsList() {
    var { token, params, getSentRequests, patients } = this.props;
    return (
      <SentRequestsList surveyId = { params.id }
        getSentRequests = { getSentRequests }
        token = { token }
        careteamPatients = { patients }
      />
    );
  }

  renderSurveyElements() {
    var { isFetching, view } = this.state;
    if (isFetching) {
      return <PreLoader visible = { true } />
    }
    else if ( view === 'questions' ) {
      return this.renderSurveyQuestions()
    }
    else if ( view === 'requests' ) {
      return this.renderSentRequestsList();
    }
  }

  render() {
    var { state, props, handleViewChangeClick } = this;
    var { view, survey } = state;
    return (
      <span>
        <div className = 'row'>
          <h5 className = 'text-center text-capitalize'>
            { survey.name }
          </h5>
        </div>
        <div className = 'row margin-top-15'>
          <div className = 'col-sm-10 col-md-offset-1'>
            <ReactBootstrap.Nav
              bsStyle = 'tabs'
              onSelect = { handleViewChangeClick }
              activeKey = { String(_.indexOf(viewMap, view) + 1) }>
              <ReactBootstrap.NavItem eventKey = '1'>
                Survey Results
              </ReactBootstrap.NavItem>
              { renderSentRequestsTab(props.user) }
            </ReactBootstrap.Nav>
            { this.renderSurveyElements() }
          </div>
        </div>
      </span>
    )
  }
}

SurveyView.propTypes = {
  getSurvey: PropTypes.func.isRequired,
  params: PropTypes.object.isRequired
}

viewMap = ['questions', 'requests'];

var renderSentRequestsTab = (user) => {
  if (isPhysician(user)) {
    return (
      <ReactBootstrap.NavItem eventKey = '2'>
        Sent Requests
      </ReactBootstrap.NavItem>
    );
  }
}
