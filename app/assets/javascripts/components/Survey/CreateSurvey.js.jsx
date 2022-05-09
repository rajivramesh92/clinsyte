class CreateSurvey extends Component {

  constructor(props) {
    super(props);
    this.state = {
      questions: _.map(_.range(5), num => {
        return { description : '' }
      })
    }
    this.handleOnCreateClick = this.handleOnCreateClick.bind(this);
  }

  anyEmptySpecs(questions) {
    var allChoices = _.pluck(_.filter(questions, { category: MULTIPLE_CHOICE }), 'attrs');

    var emptyDescriptions = _.some(questions, { description: '' });

    var emptyChoices = _.some(allChoices, choiceOptions => {
      return _.some(choiceOptions, { option: '' })
    });

    return emptyChoices || emptyDescriptions;
  }

  handleOnCreateClick(event) {
    var questions_attributes = this.refs.questions.getQuestions();
    var name = this.refs.name.getName();
    var treatment_plan_dependent = this.refs.treatmentPlanDependent.checked;

    if( _.isEmpty(questions_attributes) ) {
      showToast('Atleast one question is needed to create survey', 'error');
    }
    else if (_.isEmpty(name) || this.anyEmptySpecs(questions_attributes)) {
      showToast('Empty values are not allowed anywhere in the survey', 'error');
    }
    else {
      var survey = { name, questions_attributes, treatment_plan_dependent };
      this.props.sendSurvey(this.props.token, { survey }, null, () => {
        this.props.history.push('/surveys');
      })
    }
  }

  render() {
    return (
      <div className = 'col-md-8 col-md-offset-2'>
        <div className = 'panel panel-primary'>
          <div className = 'panel-body'>
            <h5 className = 'text-center'>
              New Survey
              <Note header = 'Empty questions'
                message = 'Empty questions will not be stored'
                className = 'pull-right'
              />
            </h5>
            <div className = 'margin-top-40'>
              <SurveyNameForm ref = 'name' />
              <div className = 'checkbox'>
                <label>
                  <input type = 'checkbox'
                    ref = 'treatmentPlanDependent'
                  />
                  &nbsp;
                  Treatment plan dependent survey
                </label>
              </div>
            </div>
            <div className = 'margin-top-15'>
              <QuestionInputList questions = { this.state.questions }
                ref = 'questions'
                lists = { this.props.lists }
              />
            </div>
            <div className = 'margin-top-15'>
              <button className = 'btn-primary btn std-btn pull-right'
                onClick  = { this.handleOnCreateClick }>
                <Icon icon = { SURVEY_ICON }/>&nbsp;Create
              </button>
            </div>
          </div>
        </div>
      </div>
    )
  }
}

CreateSurvey.propTypes = {
  token: PropTypes.object.isRequired,
  sendSurvey: PropTypes.func.isRequired,
  lists: PropTypes.array.isRequired
}
