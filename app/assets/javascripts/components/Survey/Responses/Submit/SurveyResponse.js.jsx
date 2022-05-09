class SurveyResponse extends Component {

  constructor(props) {
    super(props);
    this.state = {
      request: {},
      state: null,
      isFetching: true,
      validation: false
    }
    this.handleClickOnStart = this.handleClickOnStart.bind(this);
    this.handleClickOnSubmit = this.handleClickOnSubmit.bind(this);
  }

  componentDidMount() {
    var requestId = this.props.params.requestId
    var token = this.props.token
    this.props.getSurveyRequest(token, requestId, (request) => {
      this.setState({
        request,
        state: request.state,
        isFetching: false
      })
    })
  }

  handleClickOnStart(event) {
    var token = this.props.token
    var request = this.state.request;
    var surveyId = request.survey.id
    var requestId = request.id
    showToast('Please wait', 'success');
    this.props.startSurvey(token, surveyId, requestId, (startedAt) => {
      showToast('You can start answering the survey', 'success')
      this.setState({
        request: {...this.state.request, started_at: startedAt },
        state: 'started'
      })
    })
  }

  handleClickOnSubmit(event) {
    var responses = this.refs.responseList.getResponses();
    this.setState({ validation: true });
    var anyEmptyResponse = _.any(_.map(_.pluck(responses, 'response'), (response) => {
      return _.compact(Array.isArray(response) ? response : [ response ]);
    }), _.isEmpty);
    if (anyEmptyResponse) {
      showToast('Please fill all the answers', 'error');
    }
    else {
      var surveyId = this.state.request.survey.id;
      var token = this.props.token;
      var requestId = this.state.request.id;

      var survey = {
        request_id: requestId,
        responses,
      }

      this.props.sendResponse(token, surveyId, survey, (request) => {
        showToast('Your response has been recorded', 'success')
        this.setState({
          request,
          state: 'submitted'
        })
      })
    }
  }

  renderTimeStamps() {
    var timeStamps = ['sent_at', 'started_at', 'submitted_at'];
    var request = this.state.request;
    return renderItems(timeStamps, timeStamp => {
      return (
        <div className = 'col-sm-3'
          key = { timeStamp }>
          <Icon icon = { TIME_ICON } />&nbsp;
          { capitalize(timeStamp.substring(0, _.indexOf(timeStamp, '_'))) }:&nbsp;
          <i>
            { request[timeStamp] ? moment(request[timeStamp]).format('LLL') : '-' }
          </i>
        </div>
      )
    })
  }

  renderStartSurvey(survey) {
    return (
      <div>
        <button className = 'btn std-btn btn-primary font-size-14'
          onClick = { this.handleClickOnStart }>
          <Icon icon = { SURVEY_START_ICON }/>&nbsp;
          Start
        </button>
        <div className = 'font-bold font-size-18'>
          Questions
        </div>
        <QuestionsList questions = { survey.questions }/>
      </div>
    )
  }

  renderResponseList(survey) {
    return (
      <div>
        <div className = 'font-bold font-size-18'>
          Submit your response
        </div>
        <ResponseList questions = { survey.questions }
          validation = { this.state.validation }
          ref = 'responseList'
        />
        <button className = 'std-btn btn btn-primary font-size-14'
          onClick = { this.handleClickOnSubmit }>
          <Icon icon = { SUBMIT_ICON } />&nbsp;
          Submit
        </button>
      </div>
    )
  }

  renderResponseViewList(survey) {
    return (
      <div>
        <h5 className = 'text-center'>
          Response
        </h5>
        <ResponseViewList attributes = { survey.attributes }/>
      </div>
    )
  }

  renderLoadingComponent() {

  }

  renderSurvey() {
    var request = this.state.request;
    if(request) {
      if(this.state.state === 'pending') {
        return this.renderStartSurvey(request.survey);
      }
      else if (this.state.state === 'started') {
        return this.renderResponseList(request.survey);
      }
      else if (this.state.state === 'submitted') {
        return this.renderResponseViewList(request.survey);
      }
    }
    else {
      return this.renderLoadingComponent();
    }
  }

  render() {
    var survey = this.state.request.survey
    var request = this.state.request
    return (
      <div className = 'row'>
        <div className = 'col-xs-12'>
          <h5 className = 'text-center text-capitalize'>
            { survey ? survey.name : '' }
          </h5>
          <PreLoader visible = { this.state.isFetching }/>
        </div>
        <div className = 'font-size-14 margin-top-40'>
          <div className = 'col-sm-3'>
            <UserIcon user = { request.sender }/>&nbsp;
            Sent By:&nbsp;
            <span className = 'font-bold'>
              { request.sender ? request.sender.name : '-' }
            </span>
          </div>
          { this.renderTimeStamps() }
        </div>
        <div className = 'margin-top-40 col-sm-10 col-sm-offset-1'>
          { this.renderSurvey() }
        </div>
      </div>
    )
  }
}

SurveyResponse.propTypes = {

}
