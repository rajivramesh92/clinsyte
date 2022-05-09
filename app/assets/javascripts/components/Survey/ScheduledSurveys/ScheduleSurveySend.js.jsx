class ScheduleSurveySend extends Component {

  constructor(props) {
    super(props);

    this.state = {
      eventDependent: [],
      eventIndependent: [],
      conditions: [],
      therapies: [],
      fetchingDependent: true,
      fetchingIndependent: true
    }

    this.deleteSchedule = this.deleteSchedule.bind(this);
    this.configureScheduler = this.configureScheduler.bind(this);
  }

  componentDidMount() {
    var token = this.props.token;

    this.props.getSchedules(token, 'eventDependent', schedules => {
      this.setState({
        eventDependent: schedules,
        fetchingDependent: false
      })
    })

    this.props.getSchedules(token, 'eventIndependent', schedules => {
      this.setState({
        eventIndependent: schedules,
        fetchingIndependent: false
      })
    })

    this.props.getChartItems('conditions', token, conditions => {
      this.setState({
        conditions
      })
    })

    this.props.getChartItems('therapies', token, therapies => {
      this.setState({
        therapies
      })
    })
  }

  configureScheduler(data, type) {
    var token = this.props.token;
    this.props.configureScheduler(data, token, type, schedule => {
      var schedules = [...this.state[type]].concat(schedule);

      this.setState({
        [type]: schedules
      })
    })
  }

  deleteSchedule(scheduleId, type) {
    var token = this.props.token;
    this.props.deleteSchedule(scheduleId, token, type, () => {
      this.setState({
        [type]: _.reject([...this.state[type]], { id: scheduleId })
      })
    })
  }

  render() {
    var props = this.props;
    var token = props.token;
    var surveys = props.surveys;
    return (
      <div>
        <div className = 'row'>
          <div className = 'col-sm-6'>
            <IntervalSurveyScheduler surveys = { surveys }
              configureScheduler = { this.configureScheduler }
              conditions = { this.state.conditions }
              therapies = { this.state.therapies }
              token = { this.props.token }
             />
           </div>
           <div className = 'col-sm-6'>
            <ScheduledSurveysList type = 'eventIndependent'
              schedules = { this.state.eventIndependent }
              onDelete = { this.deleteSchedule }
              isFetching = { this.state.fetchingIndependent }
            />
          </div>
        </div>
        <div className = 'row'>
          <div className = 'col-sm-6'>
            <EventSurveyScheduler surveys = { surveys }
              configureScheduler = { this.configureScheduler }
              conditions = { this.state.conditions }
              therapies = { this.state.therapies }
              token = { this.props.token }
            />
          </div>
          <div className = 'col-sm-6'>
            <ScheduledSurveysList type = 'eventDependent'
              schedules = { this.state.eventDependent }
              onDelete = { this.deleteSchedule }
              isFetching = { this.state.fetchingDependent }
            />
          </div>
        </div>
      </div>
    )
  }
}

ScheduleSurveySend.propTypes = {
  surveys: PropTypes.array.isRequired,
  token: PropTypes.object.isRequired,
  configureScheduler: PropTypes.func.isRequired,
  getSchedules: PropTypes.func.isRequired,
  deleteSchedule: PropTypes.func.isRequired
}
