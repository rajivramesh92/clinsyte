class IntervalSurveyScheduler extends Component {

  constructor(props) {
    super(props);
    this.handleClickOnSchedule = this.handleClickOnSchedule.bind(this);
  }

  handleClickOnSchedule(event) {
    event.preventDefault();
    var schedule = this.refs.scheduler.getSchedule();
    var survey = this.refs.surveys.getSurvey();
    var data = {
      days: schedule.days,
      from_date: moment(schedule.fromDate).format(REQUEST_DATE_FORMAT),
      schedule_time: moment(schedule.scheduleTime).format('HH:mm:ss'),
      survey_id: survey.id,
      filters: {
        conditions: this.refs.conditions.getChartItems(),
        therapies: this.refs.therapies.getChartItems()
      }
    }
    if(_.compact(data).length == 5) {
      this.props.configureScheduler(data, 'eventIndependent');
    }
    else {
      showToast('Please select a survey and no of days to schedule survey request', 'error');
    }
  }

  render() {
    return (
      <div className = 'row'>
        <h5 className = 'text-center'>
          Schedule Periodic Surveys
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
          <label className = 'font-bold blue'>
            <em>Survey Repeat period</em>
          </label>
          <DayScheduler defaultDays = { 7 }
            ref = 'scheduler'
          />
        </div>
        <button className = 'std-btn btn btn-primary margin-top-40 pull-right'
          onClick = { this.handleClickOnSchedule }>
          <Icon icon = { SCHEDULE_SURVEY_ICON } />&nbsp;
          Schedule
        </button>
      </div>
    )
  }
}

IntervalSurveyScheduler.propTypes = {
  surveys: PropTypes.array.isRequired,
  configureScheduler: PropTypes.func.isRequired,
  conditions: PropTypes.array,
  therapies: PropTypes.array
}
