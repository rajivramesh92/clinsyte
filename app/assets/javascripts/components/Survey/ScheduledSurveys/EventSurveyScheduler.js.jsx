class EventSurveyScheduler extends Component {

  constructor(props) {
    super(props);
    this.state= {
      minutes: 0
    }

    this.handleMinutesChange = this.handleMinutesChange.bind(this);
    this.handleClickOnSchedule = this.handleClickOnSchedule.bind(this);
  }

  handleMinutesChange(event) {
    var minutes = Number(event.currentTarget.value);
    if (!_.isNaN(minutes)) {
      this.setState({
        minutes
      })
    }
  }

  handleClickOnSchedule() {
    var data = {
      survey_id: this.refs.surveys.getSurvey().id,
      time: this.state.minutes,
      filters: {
        conditions: this.refs.conditions.getChartItems(),
        therapies: this.refs.therapies.getChartItems()
      }
    }

    if(_.compact(data).length === 3) {
      this.props.configureScheduler(data, 'eventDependent');
    }
    else {
      showToast('Please select a survey and no of minutes to schedule survey request', 'error');
    }
  }

  render() {
    return (
      <div className = 'row'>
        <h5 className = 'text-center'>
          Schedule Post Medication Survey
        </h5>
        <div>
          <label className = 'font-bold blue'>
            <em>Survey To Schedule</em>
          </label>
          <SurveysSelect ref = 'surveys'
            surveys = { this.props.surveys }
            token = { this.props.token }
          />
          <label className = 'font-bold blue margin-top-7'>
            <em>Send To Patients With Conditions</em>
          </label>
          <ChartItemsSelect ref = 'conditions'
            charItems = { this.props.conditions }
            itemLabel = 'conditions'
          />
          <label className = 'font-bold blue margin-top-7'>
            <em>Send To Patients With Therapies</em>
          </label>
          <ChartItemsSelect ref = 'therapies'
            charItems = { this.props.therapies }
            itemLabel = 'Therapies'
          />
          <div className = 'form-group'>
            <label className = 'font-bold blue'>
              <em>Post Medication Waiting Period</em>
            </label>
            <div className = 'input-group'>
              <input className = 'form-control'
                onChange = { this.handleMinutesChange }
                value = { this.state.minutes }
                ref= 'minutes'
              />
              <label className = 'font-bold font-size-14 input-group-addon'>Minutes</label>
            </div>
          </div>
        </div>
        <button className = 'std-btn btn btn-primary margin-top-40 pull-right'
          onClick = { this.handleClickOnSchedule }>
          <Icon icon = { SCHEDULE_SURVEY_ICON } />&nbsp;
          schedule
        </button>
      </div>
    )
  }
}

EventSurveyScheduler.propTypes = {
  surveys: PropTypes.array.isRequired,
  configureScheduler: PropTypes.func.isRequired,
  conditions: PropTypes.array,
  therapies: PropTypes.array
}
