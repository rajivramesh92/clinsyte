class ScheduledSurveysList extends Component {

  constructor(props) {
    super(props);
    this.state = {
      schedules: props.schedules,
      isFetching: props.isFetching
    }

    this.handleDeleteClick = this.handleDeleteClick.bind(this);
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      schedules: nextProps.schedules,
      isFetching: nextProps.isFetching
    })
  }

  handleDeleteClick(scheduleId) {
    var type = this.props.type;
    return (event) => {
      event.preventDefault();
      this.props.onDelete(scheduleId, type)
    }
  }

  renderEventDependent(schedule) {
    return (
      <span>
        <span>
          after&nbsp;
        </span>
        <span className = 'font-bold'>
          { schedule.time } minute(s)
        </span>
        <span>
          &nbsp;of every dosage
        </span>
      </span>
    )
  }

  renderEventIndependent(schedule) {
    var scheduleTime = () => {
      return (
        <span className = 'font-bold'>
          { moment(schedule.schedule_time, 'HH:mm:ss').format('hh:mm A') }
        </span>
      );
    }

    return (
      <span>
        <span>
          in every&nbsp;
        </span>
        <span className = 'font-bold'>
          { schedule.days } day(s),&nbsp;
        </span>
        <span>
          starting from&nbsp;
        </span>
        <span className = 'font-bold'>
          { moment(schedule.from_date).format('MMM Do YYYY') }
        </span>
        { schedule.schedule_time ? <span>&nbsp;at&nbsp;{ scheduleTime() }</span> : '' }
      </span>
    )
  }

  renderSchedules() {
    if (this.state.isFetching) {
      return <PreLoader visible = { true }/>
    }

    var schedules = this.state.schedules;
    if (_.isEmpty(schedules)) {
      return (
        <NoItemsFound icon = { SCHEDULE_SURVEY_ICON }
          message = 'No Survey Scheduled'
        />
      )
    }

    var type = this.props.type;
    var renderPeriod = type === 'eventDependent' ? this.renderEventDependent : this.renderEventIndependent;

    return renderItems(schedules, (schedule, index) => {
      return (
        <li className = 'list-group-item'
        key = { schedule.id }>
            <div className = 'vertically-centered'>
              { index + 1}.&nbsp;
            </div>
            <div className = 'vertically-centered full-width'>
              <SurveyLink survey = { schedule.survey } />&nbsp;
              { renderPeriod(schedule) }
              <button className = 'btn btn-link survey-del-btn pull-right'
                onClick = { this.handleDeleteClick(schedule.id) }>
                <span title = 'Delete'>
                  <Icon icon = { DELETE_ICON }/>
                </span>
              </button>
            </div>
        </li>
      )
    });
  }

  render() {
    return (
      <div>
        <h5 className = 'text-center'>
          Scheduled Surveys
        </h5>
        <ScrollingList name = { this.props.type }
          height = { 350 }>
          <ul className = 'list-group'>
            { this.renderSchedules() }
          </ul>
        </ScrollingList>
      </div>
    )
  }
}

ScheduledSurveysList.propTypes = {
  schedules: PropTypes.array.isRequired,
  type: PropTypes.oneOf(['eventDependent', 'eventIndependent']).isRequired,
  onDelete: PropTypes.func.isRequired
}
