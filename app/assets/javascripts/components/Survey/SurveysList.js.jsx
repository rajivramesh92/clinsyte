class SurveysList extends Component {

  constructor(props) {
    super(props);
    var surveys = props.surveys;
    this.state = {
      showModal: false,
      clickedSurvey: {},
      surveys: surveys || [],
      allSurveysLoaded: _.isEmpty(surveys),
      fetching: false
    }
    this.renderSurvey = this.renderSurvey.bind(this);
    this.modalClose = this.modalClose.bind(this);
    this.deleteSurvey = this.deleteSurvey.bind(this);
    this.renderSurveys = this.renderSurveys.bind(this);
    this.loadSurveys = this.loadSurveys.bind(this);
  }

  componentWillReceiveProps(nextProps, prevProps) {
    this.setState({
      surveys: nextProps.surveys || prevProps.surveys
    });
  }

  handleOnDelete(survey) {
    return (event) => {
      this.setState({
        showModal: true,
        clickedSurvey: survey
      })
    }
  }

  loadSurveys(page){
    this.setState({
      isFetching: true
    });

    this.props.getSurveys(page, this.props.token, newSurveys => {
      var allSurveysLoaded = isFetching = false;

      if (_.isEmpty(newSurveys)) {
        allSurveysLoaded = true;
      }

      this.setState({ isFetching, allSurveysLoaded });
    });
  }

  deleteSurvey() {
    var surveyId = this.state.clickedSurvey.id
    var token = this.props.token
    var that = this;
    this.props.deleteSurvey(token, surveyId, ()=> {
      that.setState({
        surveys: _.reject([...that.state.surveys], { id: surveyId }),
        showModal: false,
        clickedSurvey: {}
      })
    })
  }

  modalClose() {
    this.setState({
      showModal: false,
      clickedSurvey: {}
    })
  }

  renderSurveyOptions(survey) {
    var user = this.props.user;
    var creatorId = survey.creator ? survey.creator.id : user.id;

    if(user && (creatorId == user.id || isAdmin(user)) || isStudyAdmin(user)) {

      var editButton = (
        <span>
          <Link to = { '/surveys/' + survey.id + '/edit' }
            title = 'Edit'>
            <Icon icon = { EDIT_ICON }/>
          </Link>
        </span>
      );

      return (
        <span className = 'pull-right'>
          { survey.editable ? editButton : '' }
          <span className = 'margin-left-20'>
            <button className = 'btn btn-link survey-del-btn font-size-15'
              onClick = { this.handleOnDelete(survey) }>
              <Icon icon = { DELETE_ICON }/>
            </button>
          </span>
        </span>
      );
    }
  }

  renderSurvey(survey, index) {
    return (
      <li className = 'list-group-item'
        key = { survey.id }>
        <div className = 'display-table-cell'>
          { index + 1 }.&nbsp;
        </div>
        <div className = 'vertically-centered full-width'>
          <SurveyLink survey = { survey } />
          { this.renderSurveyOptions(survey) }
        </div>
      </li>
    )
  }

  renderSurveys() {
    if(_.isEmpty(this.state.surveys)) {
      return (
        <NoItemsFound icon = { SURVEY_ICON }
          message = { 'No surveys' }
        />
      )
    }
    else {
      return (
        <ul className = 'list-group margin-top-15'>
          <InfiniteScroll name = 'surveys'
            height ={ 300 }
            complete = { this.state.allSurveysLoaded }
            loading = { this.state.isFetching }
            loadMore = { this.loadSurveys }
            page = { parseInt((this.state.surveys.length - 1) / 10) + 1 }>
            { renderItems(this.state.surveys, this.renderSurvey) }
          </InfiniteScroll>
        </ul>
      );
    }
  }

  renderButtons(){
    var buttonClassName = 'btn btn-primary std-btn';
    var buttons = [
      { to: '/surveys/create', icon: SURVEY_ICON, val: 'create' },
      { to: '/surveys/send', icon: SEND_SURVEY_ICON, val: 'send' },
      { to: '/surveys/send/scheduler', icon: SCHEDULE_SURVEY_ICON, val: 'schedule' }
    ]

    return renderItems(buttons, (button, index) => {
      return (
        <div key = { index }
         className = 'col-sm-4 margin-top-15'>
          <LinkButton to = { button.to }
            className = { buttonClassName }
            val = { <span><Icon icon = { button.icon } />&nbsp;{ button.val }</span>}
          />
        </div>
      )
    })
  }

  render() {
    return (
      <div className = 'row'>
        <div className = 'col-md-8 col-md-offset-2'>
          <h5 className = 'text-center'>
            Surveys
          </h5>
          <div className = 'row'>
            <div className = 'col-sm-8 col-sm-offset-2 margin-top-15 text-center'>
              { isPhysician(this.props.user) ? this.renderButtons() : null }
            </div>
          </div>
          <div className = 'row'>
            { this.renderSurveys() }
          </div>
          <Modal show = { this.state.showModal }
          onHide = { this.modalClose }>
            <Modal.Header closeButton>
              <span className = 'font-size-18'>
                Are you sure you want to delete survey:&nbsp;&nbsp;
                <b>
                  { this.state.clickedSurvey.name }
                </b>
              </span>
            </Modal.Header>
            <Modal.Footer>
              <Button onClick = { this.modalClose }>Close</Button>
              <Button bsStyle = 'primary'
              onClick = { this.deleteSurvey }>YES</Button>
            </Modal.Footer>
          </Modal>
        </div>
      </div>
    )
  }
}

SurveysList.propTypes = {
  surveys: PropTypes.array.isRequired,
  deleteSurvey: PropTypes.func,
  token: PropTypes.object,
  user: PropTypes.object
}
