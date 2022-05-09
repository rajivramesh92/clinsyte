class EditSurvey extends Component {

  constructor(props) {
    super(props);
    this.state = {
      survey: { questions: [] },
      newQuestions: [{ description: '' }]
    }
    this.onDelete = this.onDelete.bind(this);
    this.handleOnUpdateClick = this.handleOnUpdateClick.bind(this);
  }

  onDelete(id) {
    return (event) => {
      survey = {...this.state.survey};
      survey.questions[_.findIndex(survey.questions, { id })].status = 'inactive';
      this.setState({
        survey
      })
    }
  }

  handleOnUpdateClick(event) {
    var name = this.refs.name.getName();
    var newQuestions = this.refs.newQuestions.getQuestions();
    var survey = _.omit(this.state.survey, 'questions');
    var survey = {
      ...survey,
      name,
      questions_attributes: [...this.state.survey.questions].concat(newQuestions)
    }
    this.refs.newQuestions.clearQuestions();
    this.props.sendSurvey(this.props.token, { survey }, survey.id, (newSurvey) => {
      this.setState({
        survey: newSurvey
      })
    });
  }

  componentDidMount() {
    var surveyId = this.props.params.id;
    var token = this.props.token;
    this.props.getSurvey(token, surveyId, (survey) => {
      if (survey.editable) {
        this.setState({ survey })
      }
      else {
        showToast('Survey cannot be edited', 'error');
        this.props.history.push('surveys/' + surveyId);
      }
    })
  }

  render() {
    return (
      <div>
        <div className = 'row'>
          <h5 className = 'text-center'>Edit Survey</h5>
          <div className = 'col-md-2'>
            <h5>Survey Title:</h5>
          </div>
          <div className = 'col-md-8'>
            <SurveyNameForm ref = 'name'
              name = { this.state.survey.name }
            />
          </div>
        </div>
        <div className = 'row margin-top-40'>
          <div className = 'col-md-2'>
            <h5>Existing Questions:</h5>
            <small className = 'text-danger'>
              <em>(These are uneditable)</em>
            </small>
          </div>
          <div className = 'col-md-8'>
            <QuestionsList questions = { this.state.survey.questions }
              onDelete = { this.onDelete }
            />
          </div>
        </div>
        <div className = 'row margin-top-40'>
          <div className = 'col-md-2'>
            <h5>Add New Questions:</h5>
          </div>
          <div className = 'col-md-8'>
            <QuestionInputList questions = { this.state.newQuestions }
              ref = 'newQuestions'
              lists = { this.props.lists }
            />
          </div>
        </div>
        <div className = 'row margin-top-40'>
          <div className = 'col-md-2 col-md-offset-8'>
            <button className = 'btn btn-primary'
              onClick = { this.handleOnUpdateClick }>
              UPDATE
            </button>
          </div>
        </div>
      </div>
    )
  }
}

EditSurvey.propTypes = {
  token: PropTypes.object.isRequired,
  sendSurvey: PropTypes.func.isRequired,
  getSurvey: PropTypes.func.isRequired
}
