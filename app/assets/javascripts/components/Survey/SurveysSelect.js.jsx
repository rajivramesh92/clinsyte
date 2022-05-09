class SurveysSelect extends Component {

  constructor(props) {
    super(props);
    this.state = {
      selectedSurvey: null
    }

    this.handleSurveyChange = this.handleSurveyChange.bind(this);
    this.loadOptions = this.loadOptions.bind(this);
  }

  getSurvey() {
    var selectedSurvey = this.state.selectedSurvey || {};
    return {
      id: selectedSurvey.value,
      name: selectedSurvey.label
    }
  }

  clear() {
    this.setState({
      selectedSurvey: null
    })
  }

  getSurveyOptions(surveys) {
    return _.map(surveys, survey => {
      return {
        value: survey.id,
        label: renderSurveyLabel(survey)
      }
    })
  }

  handleSurveyChange(selectedSurvey) {
    this.setState({
      selectedSurvey
    })
  }

  loadOptions(input, callback) {
    var { surveys, token } = this.props;
    var options = [];

    if (this.timeOut) {
      clearTimeout(this.timeOut);
    }

    this.timeOut = setTimeout(_ => {
      getSurveys(1, token, (response, error) => {
        if ( response && response.data.status === 'success') {
          var options = this.getSurveyOptions(response.data.data);
          callback(null, { options });
        }
      }, input)
    }, 1000)

  }

  render() {
    return (
      <Select.Async name = 'survey-select'
        placeholder = 'Choose a survey...'
        value = { this.state.selectedSurvey }
        onChange = { this.handleSurveyChange }
        loadOptions = { this.loadOptions }
      />
    )
  }
}

SurveysSelect.propTypes = {
  surveys: PropTypes.array
}

var renderSurveyLabel = (survey) => {
  return (
    <span>
      { survey.name }
      &nbsp;
      { survey.treatment_plan_dependent ? <label className = 'label label-success'>TPD</label> : ''}
    </span>
  )
}
